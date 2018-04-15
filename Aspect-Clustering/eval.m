a = xlsread("label_word_vector_training.xlsx");
clust = zeros(size(a,1),6);
for i=1:6
clust(:,i) = kmeans(a,i,'emptyaction','singleton',...
        'replicate',5);
end
eva = evalclusters(a,clust,'CalinskiHarabasz')  %'DaviesBouldin'
