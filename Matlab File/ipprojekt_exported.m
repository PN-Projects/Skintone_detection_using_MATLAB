classdef ipprojekt_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        GridLayout             matlab.ui.container.GridLayout
        LeftPanel              matlab.ui.container.Panel
        HexCodeText            matlab.ui.control.TextArea
        UploadButton           matlab.ui.control.Button
        StartProcessingButton  matlab.ui.control.Button
        RightPanel             matlab.ui.container.Panel
        OriginalImage          matlab.ui.control.UIAxes
        Mask                   matlab.ui.control.UIAxes
        SkinPixels             matlab.ui.control.UIAxes
        ColorAxes              matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = private)
        img % Description
        Text % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: UploadButton
        function UploadButtonPushed(app, event)
             [fname, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Images'}, 'Select Portrait Image');
            if isequal(fname, 0)
                uialert(app.UIFigure, 'Image selection canceled', 'Error');
                return;
            else
                app.img = imread(fullfile(path, fname));
                figure('Name', 'Original'); imshow(app.img);
            end
        end

        % Button pushed function: StartProcessingButton
        function StartProcessingButtonPushed(app, event)

    img = app.img;

    % Display the original image in the OriginalImage axis
    imshow(img, 'Parent', app.OriginalImage);
    
    % Popup the image for manual skin selection
    figure('Name', 'Select Skin Region');
    imshow(img);
    disp('Select skin region');
    rect = imrect; % Manual selection in the popup window
    pos = round(wait(rect));
    
    % Check if a valid region was selected
    if isempty(pos)
        uialert(app.UIFigure, 'No valid region selected', 'Error');
        return;
    end

    % Crop the selected skin region for further processing
    skin = imcrop(img, pos);

    % Step 3: Skin segmentation in YCbCr & HSV
    ycbcr = rgb2ycbcr(skin);
    cb = ycbcr(:,:,2); cr = ycbcr(:,:,3);
    mask1 = (cb >= 77) & (cb <= 127) & (cr >= 133) & (cr <= 173);

    hsv = rgb2hsv(skin);
    h = hsv(:,:,1); s = hsv(:,:,2); v = hsv(:,:,3);
    mask2 = (h >= 0.0) & (h <= 0.1) & (s >= 0.2) & (s <= 0.68) & (v >= 0.35) & (v <= 1.0);

    mask = mask1 & mask2;
    mask = imopen(mask, strel('disk', 3));
    mask = imclose(mask, strel('disk', 3));
    mask = imfill(mask, 'holes');
    imshow(mask, 'Parent', app.Mask); % Display the mask in the Mask axis

    % Step 4: Extract Skin Pixels
    skin_pix = skin;
    skin_pix(repmat(~mask, [1, 1, 3])) = 0;
    imshow(skin_pix, 'Parent', app.SkinPixels); % Display skin pixels in the SkinPixels axis

    % Step 5: Data Prep for Clustering
    skin_data = reshape(skin_pix, [], 3);
    skin_data = skin_data(any(skin_data, 2), :);
    skin_data = double(skin_data) / 255;

    % Step 6: K-means for Dominant Tone
    clust = 3; rng(1);
    [idx, centers] = kmeans(skin_data, clust, 'MaxIter', 500, 'Replicates', 5);
    dom_clust = mode(idx);
    dom_color = centers(dom_clust, :) * 255;
    dom_color = round(min(max(dom_color, 0), 255));

    % Step 7: Convert RGB to Hex
    hex = sprintf('#%02X%02X%02X', dom_color(1), dom_color(2), dom_color(3));
    app.HexCodeText.Value = ['Detected Skin Tone Hex: ', hex];
    rgbColor = sscanf(hex(2:end), '%2x%2x%2x', [1, 3]) / 255;
    fill(app.ColorAxes, [0 1 1 0], [0 0 1 1], rgbColor, 'EdgeColor', 'none');
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {532, 532};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {260, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100.2 100.2 902 532];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {260, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create StartProcessingButton
            app.StartProcessingButton = uibutton(app.LeftPanel, 'push');
            app.StartProcessingButton.ButtonPushedFcn = createCallbackFcn(app, @StartProcessingButtonPushed, true);
            app.StartProcessingButton.Position = [42 213 123 35];
            app.StartProcessingButton.Text = 'Process';

            % Create UploadButton
            app.UploadButton = uibutton(app.LeftPanel, 'push');
            app.UploadButton.ButtonPushedFcn = createCallbackFcn(app, @UploadButtonPushed, true);
            app.UploadButton.Position = [42 281 123 39];
            app.UploadButton.Text = 'Upload';

            % Create HexCodeText
            app.HexCodeText = uitextarea(app.LeftPanel);
            app.HexCodeText.Position = [42 122 132 60];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create ColorAxes
            app.ColorAxes = uiaxes(app.RightPanel);
            title(app.ColorAxes, 'colour')
            xlabel(app.ColorAxes, 'X')
            ylabel(app.ColorAxes, 'Y')
            zlabel(app.ColorAxes, 'Z')
            app.ColorAxes.Position = [324 44 280 193];

            % Create SkinPixels
            app.SkinPixels = uiaxes(app.RightPanel);
            title(app.SkinPixels, 'SkinPixels')
            xlabel(app.SkinPixels, 'X')
            ylabel(app.SkinPixels, 'Y')
            zlabel(app.SkinPixels, 'Z')
            app.SkinPixels.Position = [24 44 280 193];

            % Create Mask
            app.Mask = uiaxes(app.RightPanel);
            title(app.Mask, 'Mask')
            xlabel(app.Mask, 'X')
            ylabel(app.Mask, 'Y')
            zlabel(app.Mask, 'Z')
            app.Mask.Position = [324 273 280 193];

            % Create OriginalImage
            app.OriginalImage = uiaxes(app.RightPanel);
            title(app.OriginalImage, 'Original Image')
            xlabel(app.OriginalImage, 'X')
            ylabel(app.OriginalImage, 'Y')
            zlabel(app.OriginalImage, 'Z')
            app.OriginalImage.Position = [24 273 280 193];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ipprojekt_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
