%训练图片数
categorySizeForTraining = 7; 

folderPath = 'yalefaces/'; 
personFixs = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15'};  
categories = {'centerlight', 'glasses', 'happy', 'leftlight', 'noglasses', 'normal', 'rightlight', 'sad', 'sleepy', 'surprised', 'wink'};  

personSize = max(size(personFixs)); 
categorySize = max(size(categories)); 
%用于测试的图片数
categorySizeForTesting = categorySize - categorySizeForTraining; 

%得到矩阵W(eigenMatrix)，训练图片在特征脸上的系数(trainingVectors)，训练样本的均值(avatarXAverage)，特征脸的个数(eigenSize) 
[eigenMatrix, trainingVectors, avatarXAverage, eigenSize] = getEigenVectors(categorySizeForTraining); 

vec = cell(personSize, categorySizeForTesting); 
t = cell(personSize, categorySizeForTesting); 
accurateArray = zeros(personSize, categorySizeForTesting); %测试图片的正确矩阵，默认为0，识别正确则置1 
for x = 1 : personSize 
  for y = 1 : categorySizeForTesting
    %拼接文件名
    testSrcs{x, y} = [folderPath, 'subject', personFixs{x}, '.', categories{y + categorySizeForTraining}, '.gif']; 
    I = imread(testSrcs{x, y}); 
    I = I(:)'; 
    I = double(I) - avatarXAverage;
    %计算特征脸系数向量
    testVector = eigenMatrix' * I';
    %计算该测试图片和每一张训练图片在特征脸上的误差
    for i = 1 : personSize 
      for j = 1 : categorySizeForTraining 
        delta(i, j) = 0; 
        for k = 1 : eigenSize 
          delta(i, j) = delta(i, j) + (testVector(k) - trainingVectors{i, j}(k)) .^ 2; 
        end 
      end 
    end 

    %对误差进行排序
    vec{x, y} = delta';
    t{x, y} = []; 
    for n = 1 : categorySizeForTraining
      [d, q] = sort(vec{x, y}(n, :), 'ascend'); 
      t{x, y} = [t{x, y}; q]; 
    end 
    %使用最近邻判断该图片是哪个人的
    if mode(t{x, y}(:, 1)) == x 
      accurateArray(x, y) = 1; 
    end 
  end 
end 

accurateArray %显示每张测试图片是否被正确识别
tabulate(accurateArray(:)) %显示识别正确率
