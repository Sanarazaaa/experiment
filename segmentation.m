clearvars; close all;
im = imread('testing_1.jpg');
if size(im,3) == 3
    im_gray = rgb2gray(im);
else
    im_gray = im;
end

im_adjusted = imadjust(im_gray, [0.3 0.7], []); 
im_filtered = imgaussfilt(im_adjusted, 2);  
[height, width] = size(im_gray);

rmin = 4;
rmax = 12;
sensitivity = 0.8;  
EdgeThreshold = 0.2; 

figure(1)
imshow(im)
hold on

[centers, radii] = imfindcircles(im_filtered, [rmin rmax], ...
    'ObjectPolarity', 'bright', ...
    'Sensitivity', sensitivity, ...
    'Method', 'TwoStage', ...
    'EdgeThreshold', EdgeThreshold); 


right_boundary = width - 29; 
bottom_boundary = height - 3;  
cell_count = 0;
if ~isempty(centers)
    for i = 1:length(centers)
        x = centers(i,1);
        y = centers(i,2);
        r = radii(i);
        
    
        touches_right_boundary = (x + r) >= right_boundary;
        touches_bottom_boundary = (y + r) >= bottom_boundary;
        
        if ~touches_right_boundary && ~touches_bottom_boundary
            cell_count = cell_count + 1;
            viscircles([x,y], r, 'Color', 'g', 'LineWidth', 1);
        else
            viscircles([x,y], r, 'Color', 'r', 'LineWidth', 1);
        end
    end
end
line([right_boundary right_boundary], [0 height], 'Color', 'y', 'LineStyle', '--');
line([0 width], [bottom_boundary bottom_boundary], 'Color', 'y', 'LineStyle', '--');

square_volume_ml = 0.0001;
concentration = cell_count / square_volume_ml;

text(10, 30, sprintf('Counted cells: %d', cell_count), ...
    'Color', 'green', 'FontSize', 12, 'BackgroundColor', 'black');

title('Bright Cell Count (Excluding Boundary Regions)');
hold off
fprintf('\nHemocytometer Cell Count Results:\n');
fprintf('----------------------------------------\n');
fprintf('Total cells counted: %d\n', cell_count);
fprintf('Estimated concentration: %.2e cells/mL\n', concentration);
