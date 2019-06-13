# audio2stl
Converts an audio file to a 3D spectrogram and (optionally) saves as a stereolithography (STL) file for 3D printing

Date: 2019-06-13

Author: Christopher Carignan

Email: c.carignan@phonetik.uni-muenchen.de

Institution: Institute of Phonetics and Speech Processing (IPS), Ludwig-Maximilians-Universität München, Munich, Germany

Description:

  Converts an audio file to a 3D spectrogram; (optionally) saves as a stereolithography (STL) file for 3D printing

Arguments:

  inputfile (required): filepath string associated with WAV audio file

  outputfile (optional): filepath sring associated with STL file to save

  sampfreq: re-sampling frequency

  axisnorm: keep the x- and y-axes scaling (FALSE) or normalize so that they have the same dimensions (TRUE)

  preemph: value for pre-emphasis of audio
