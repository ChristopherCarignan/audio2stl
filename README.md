# audio2stl
Converts an audio file to a 3D spectrogram and (optionally) saves as a stereolithography (STL) file for 3D printing

![example](https://github.com/ChristopherCarignan/audio2stl/blob/master/spec3d.png)


Date: 2019-06-13

Author: Christopher Carignan

Email: c.carignan@phonetik.uni-muenchen.de

Institution: Institute of Phonetics and Speech Processing (IPS), Ludwig-Maximilians-Universität München, Munich, Germany

## Description

  Converts an audio file to a 3D spectrogram; (optionally) saves as a stereolithography (STL) file for 3D printing

## Arguments

  inputfile (required): filepath string associated with WAV audio file

  outputfile (optional): filepath string associated with STL file to save

  sampfreq: re-sampling frequency

  axisnorm: keep the x- and y-axis scaling (FALSE) or normalize so that they have the same dimensions (TRUE)

  preemph: value for pre-emphasis of audio

  window: option for windowing audio using a variety of Matlab/Octave compatible filters found in the "signal" package
    ex: 'bartlett', 'blackman', 'hamming', 'hanning', 'triang'

## Requirements

  See requirements.txt for packages. Install them with the [requiRements R package](https://cran.r-project.org/web/packages/requiRements/index.html) or by hand.
  
  The author specified no minimum R version but experiments indicate that 3.6.1 is too old. 4.1.1 works like a charm, at least on Windows 10.
  
  Requirements documented by Helen Griffiths, Newcastle University IT Service.