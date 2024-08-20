PERPLEX stands for Program for Expedition Route PLanning and EXecution. I, Gerd Rohardt, a physical oceanographer, had developed this software in Matlab® during working at AWI, Bremerhaven, Germany – since January 2022 retired.
At AWI PERPLEX has been used for about 22 years, mainly for cruises with RV POLARSTERN and supports the chief scientist in the coordination of various scientific programs. PERPLEX has also proven its efficiency with small research vessels too during short or one-day cruises.
Initially, I just wanted to "clean up" the source code and upload them to Mathworks File Exchange. However, in more than 20 years the software Perplex had grown to about 250 files. Therefore, I had decided to make the software completely new, focusing on the essential functionality needed to plan and execute a trip. Additional functions I will add step by step, e.g. "Define Section".
I welcome your comments and hope that you can use the source code to make changes as needed to more efficiently adjust Perplex7 to your institution's specific requirements.
Find further details in Perplex7-Manual.pdf

Release from February 16th 2024
The main changes in this release are:
(1) Revision of the "Map" tab, which simplifies operation; see Plot_Map.m 
(2) In addition to the EEZs, depth contours or the sea ice concentration of the Arctic or Antarctic can now also be plotted. When plotting the depth contours, the GRIDONE_2D-subset.m function ensures that the resolution is automatically adapted to the respective map section.
(3) Adding waypoints to the map interactively with the mouse has been improved.
(4) The file Default_InstrTable.mat with the instrument settings has been changed to a CSV-file (Default_InstrTable.csv). This makes it easier for users to edit the instrument settings; see Perplex-Manual page 3 and 37.
(5) Perplex-Manual.pdf has been updated.

Release 1.5.0.0 from August 2024: Cast setup of stations can be cloned. This means that a defined sequence of devices used at a station can be easily copied for several consecutive waypoints.
