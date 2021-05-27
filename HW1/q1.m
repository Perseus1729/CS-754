clear;
rng(13);

imAge(3,'cars.avi');
imAge(5,'cars.avi');
imAge(7,'cars.avi');
% imAge(3,'flame.avi');
% imAge(5,'flame.avi');
% imAge(7,'flame.avi');

function imAge(F,file)
    cars = mmread(file,F);
    filename = string(file).split(".");
    filename = filename(1)
    H = 120;
    W = 240;
    gray_cars = zeros([H,W,F]);
    for i=1:F
        gray_cars(:,:,i) = double(rgb2gray(cars.frames.cdata(end-H+1:end,end-W+1:end,:)));
    end

    E = zeros([H,W],'double');
    for i=1:F
       C(:,:,i) = double(randi([0,1],[H,W]));
       E = E + C(:,:,i).*gray_cars(:,:,i);
    end
    
    E = E + randn([H,W])*2;
    A=figure;   
    imshow(uint8(E));
    t = title(['Coded snapshot of ', filename, ' for ', num2str(F), ' frames']);
    t.FontSize = 10;
    saveas(A,['Q2_results/', char(filename), '/', num2str(F), '_coded_snapshot.jpg']);
    
    img = zeros([H,W,F],'double');
    count = zeros([H,W,F]);
    D = kron(dctmtx(8),dctmtx(8));
    psi = kron(eye(F),D);

    for i = 1:H-7
       for j = 1:W-7
           count(i:i+7,j:j+7,:) = count(i:i+7,j:j+7,:) + 1;
           A = [];
           for k = 1:F
               C_1 = reshape(C(i:i+7, j:j+7, k), 1, []);
               A = [A diag(C_1)];
           end   
           y = reshape(E(i:i+7,j:j+7), 1, []);
           d = double(OMP(y,A,psi));
           d = reshape(d, [8 8 F]);
           img(i:i+7, j: j+7,:) = img(i:i+7,j:j+7,:) + d;
       end
    end

    img = img./count;
    for i = 1:F
        Ab(i)=figure;   
        imshow(uint8(img(:,:,i)))
        t = title(strcat("Reconstructed image of ", filename, " for ", num2str(F), " frames"));
        t.FontSize = 10;
        location = strcat('Q2_results/', filename , "/" ,num2str(F), "_", num2str(i),".png")
        saveas(Ab(i),location); 
    end
    norm(gray_cars(:) - img(:))/norm(gray_cars(:))
 
    function img = OMP(y,A,psi)

        A1 = A*psi';
        [~,w] = size(A);
        r = single(y); theta = zeros([w,1],'double'); T = []; 
        while (norm(r)^2 > 9*4*64)
            pl = abs((r*A1)./(vecnorm(A1).^2));
            [~, max_column] = max(pl);
            T = [T max_column];
            theta(T) = pinv(A1(:, T)) * y'; % theta is column vector

            r = y - (A1(:,T)*theta(T))';
        end
        img = psi'*theta;
    end
end