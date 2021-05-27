clear;
rng(1234);

cars = mmread('cars.avi',3);

for i=1:3
    gray_cars(:,:,i) = rgb2gray(cars.frames.cdata(end-239:end,end-119:end,:));
end
H = 
E = zeros([H,W],'uint8');
for i=1:3
   C(:,:,i) = uint8(randi([0,1],[H,W]));
   E = E + C(:,:,i).*gray_cars(:,:,i);
end

% image(E)

x = [];
for i=1:3
    x = [x reshape(gray_cars(:,:,i),1,[])]; % columns concatenated
end

size(x)

A = [];
for i=1:3
    A = [A ; diag(reshape(C(:,:,i),1,[]))];
end
size(A)