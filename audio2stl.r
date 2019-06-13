# Filename: audio2stl.r
# Date: 2019-06-13
# Author: Christopher Carignan
# Email: c.carignan@phonetik.uni-muenchen.de
# Institution: Institute of Phonetics and Speech Processing (IPS), Ludwig-Maximilians-Universität München, Munich, Germany
# Description:
#   Converts an audio file to a 3D spectrogram; (optionally) saves as a stereolithography (STL) file for 3D printing
# Arguments:
#   inputfile (required): filepath string associated with WAV audio file
#   outputfile (optional): filepath sring associated with STL file to save
#   sampfreq: re-sampling frequency
#   axisnorm: keep the x- and y-axes scaling (FALSE) or normalize so that they have the same dimensions (TRUE)
#   preemph: value for pre-emphasis of audio


audio2stl <- function (inputfile, outputfile=NULL, sampfreq=16000, axisnorm=FALSE, preemph=0.97) {
  # Load libraries
  library(rayshader)
  library(dplyr)
  library(tuneR)
  library(matlab)
  library(png)
  
  # Function for resampling audio
  resampleWave <- function (object, samp.rate) {
    if ((!is.numeric(samp.rate)) || (samp.rate < 2000) || (samp.rate > 192000)) 
      stop("samp.rate must be an integer in [2000, 192000].")
    if (object@samp.rate > samp.rate) {
      ll      <- max(dim(object@.Data))
      object  <- object[round(seq(1, ll, length = samp.rate * ll/object@samp.rate))]
      object@samp.rate <- samp.rate
    }
    else warning("samp.rate > object's original sampling rate, hence object is returned unchanged.")
    return(object)
  }
  
  sndWav  <- tuneR::readWave(inputfile, toWaveMC=T) # load WAV file
  rsWav   <- resampleWave(sndWav, sampfreq) # resample to desired sampling frequency
  rsWav   <- tuneR::normalize(rsWav,unit="1") # scale audio
  fs      <- rsWav@samp.rate # get the sampling frequency
  snd     <- rsWav@.Data / (2^(rsWav@bit-1)) # get the audio data
  # if the file is stereo, only use the first channel
  if (length(dim(snd)) > 1){
    snd <- snd[,1]
  }
  
  # Implement preemphasis of audio, according to the function:
  # ŝ(x) = s(x)-k*s(x-1)
  snd_preemph <- rep(0, length(snd))
  for(i in 2:length(snd)){
    snd_preemph[i] <- snd[i] - preemph * snd[i - 1]
  }
  
  # Create spectrogram
  spec  <- powspec(snd_preemph, sr=fs, wintime=0.025, steptime=0.01, dither=FALSE) # power spectrum
  spec  <- 10*log10(abs(spec)) # convert to absolute spectrum
  
  # Optional normalization of dimensions of x- and y-axes
  if (axisnorm) {
    library(raster)
    
    height  <- nrow(spec)
    width   <- ncol(spec)
    
    r <- raster::raster(spec) # rasterize the spectrogram
    raster::extent(r) <- raster::extent(c(-180, 180, -90, 90)) # geographical coordinates of raster
    if (height > width) {
      s <- raster::raster(ncol=height, nrow=height) # stretch width if height > width
    } else if (width > height) {
      s <- raster::raster(ncol=width, nrow=width) # stretch height if height < width
    } else {
      return # if the dimensions are already the same, do nothing
    }
    s <- raster::resample(r,s) # resample rasterized matrix
    spec <- as.matrix(s) # convert rasterized spectrogram back to matrix object
  }
  
  # Create color map to overlay on 3D spectrogram
  tempfilename <- tempfile()
  png(tempfilename, width=ncol(spec), height=nrow(spec))
  par(mar=c(0,0,0,0))
  raster::image(matlab::fliplr(spec), axes=FALSE, col=rev(gray.colors(50, start=0, end=1)))
  dev.off()
  tempmap <- png::readPNG(tempfilename)
  
  # Create and plot the 3D spectrogram
  spec %>%
    sphere_shade(texture='bw') %>%
    add_overlay(tempmap, alphalayer = 0.7) %>%
    plot_3d(spec, zscale=1, theta=225)
  
  # If an output file is provided, save the 3D spectrogram as an STL file
  if (!is.null(outputfile)) { 
    save_3dprint(outputfile, maxwidth = 50, unit="mm")
  }
}