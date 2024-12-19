# Skintone Detection Using HSV & YCbCr mask in MATLAB 
## Introduction
This project presents an innovative MATLAB-based system for detecting skin tone and extracting its representative color in the form of a hex code. The system leverages multi-dimensional color spaces (YCbCr and HSV) combined with k-means clustering for accurate skin tone identification. Designed to be user-friendly yet robust, the extracted hex code enables practical applications such as personalized clothing color recommendations and digital styling.

The methodology integrates manual region selection with algorithmic processes, providing precise results while minimizing errors caused by lighting or background variations. This project is an accessible tool for use in digital fashion, cosmetics, and academic research.

## Steps to Set Up and Run
### System Requirements
- MATLAB version: R2023a or later (recommended for optimal compatibility).
- Operating System:
- Minimum: Windows 10 64-bit or macOS Catalina.
- Recommended: Windows 11 64-bit or macOS Ventura.
- Processor: Dual-core 2.0 GHz or higher.
- RAM: Minimum 4 GB; Recommended 8 GB or more.
### Dependencies
Before running the project, ensure the following MATLAB toolboxes are installed:

- [Image Processing Toolbox](https://in.mathworks.com/products/image-processing.html): Used for image manipulation and processing.
- [Statistics and Machine Learning Toolbox](https://in.mathworks.com/products/statistics.html): Required for k-means clustering.
  
### Running the Application

<h4>Clone the Repository</h4>
<p>Download the code files or clone the repository to your local machine.</p>
<pre><code>
git clone &lt;repository-url&gt;
</code></pre>

<h4>Launch MATLAB</h4>
<p>Open MATLAB and navigate to the folder containing the application files.</p>

<h4>Run the Application</h4>
<p>Execute the main file (<code>ipprojekt_exported.mlapp</code>) by typing the following command in MATLAB’s Command Window:</p>
<pre><code>
ipprojekt_exported
</code></pre>

<h4>Upload an Image</h4>
<ul>
  <li>Click the "Upload" button and select an image (supported formats: JPG, PNG, BMP).</li>
  <li>The selected image will be displayed for reference.</li>
</ul>

<h4>Select Skin Region</h4>
<ul>
  <li>A manual selection tool will appear. Use it to draw a rectangle around the skin region of the image.</li>
  <li>Ensure the selected area contains only skin for accurate detection.</li>
</ul>

<h4>Process the Image</h4>
<ul>
  <li>Click the "Process" button to start the analysis.</li>
  <li>The system will:
    <ul>
      <li>Generate a skin mask.</li>
      <li>Extract skin pixels.</li>
      <li>Perform k-means clustering to identify the dominant tone.</li>
      <li>Display the hex code and dominant skin tone.</li>
    </ul>
  </li>
</ul>
<h3>System Features</h3>
<ul>
  <li><strong>Dual-Color Space Segmentation:</strong>
    <p>Uses YCbCr and HSV color spaces to ensure reliable skin tone detection under diverse lighting conditions.</p>
  </li>
  <li><strong>Manual Skin Region Selection:</strong>
    <p>Provides flexibility for precise region identification.</p>
  </li>
  <li><strong>Clustering for Dominance:</strong>
    <p>k-means clustering isolates the dominant skin tone, reducing noise and errors.</p>
  </li>
  <li><strong>Hex Code Representation:</strong>
    <p>Converts RGB values of the dominant tone into a hex code, offering a standardized reference.</p>
  </li>
  <li><strong>Clothing Recommendations:</strong>
    <p>Outputs complementary clothing colors tailored to the detected skin tone.</p>
  </li>
</ul>

<h3>Additional Notes</h3>
<ul>
  <li>Ensure high-quality images are used for better results. Poor lighting or low resolution may affect accuracy.</li>
  <li>If encountering any issues, verify that all toolboxes are installed and the MATLAB version meets the system requirements.</li>
</ul>

<h3>Future Improvements</h3>
<ul>
  <li>Automating skin region detection using deep learning techniques.</li>
  <li>Supporting additional color spaces (e.g., Lab, Luv) for higher precision.</li>
  <li>Expanding recommendations with a machine learning-based algorithm.</li>
</ul>


# LICENSE
<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/PN-Projects/Skintone_detection_using_MATLAB">Skintone Detection using HSV & YCbCr mask</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/satyanandatripathi">Parthiv Katapara</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-nd/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nd.svg?ref=chooser-v1" alt=""></a></p>
