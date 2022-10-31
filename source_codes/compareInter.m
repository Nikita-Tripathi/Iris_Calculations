% Supplementary material for the paper:
% Adam Czajka, Daniel Moreira, Kevin W. Bowyer, Patrick J. Flynn, 
% "Domain-Specific Human-Inspired Binarized Statistical Image Features for 
% Iris Recognition," WACV 2019, Hawaii, 2019
% 
% Pre-print available at: https://arxiv.org/abs/1807.05248
% 
% Please follow the instructions at https://cvrl.nd.edu/projects/data/ 
% to get a copy of the test database.
%
% This example code demonstrates how to calculate and match binary iris 
% codes using domain-specific filters. One can easily replace 
% domain-specific filters with standard BSIF filters, if needed. In this 
% example we use an example filter set derived from eyetracker-based iris 
% image patches.

clear all

%% Load the selected domain-specific filter set
l = 15;     % size of the filer
n = 7;      % number of kernels in a set
filters = ['../iris_sourced_filters/new_bsif_filters_based_on_eyetracker_data/ICAtextureFilters_' num2str(l) 'x' num2str(l) '_' num2str(n) 'bit.mat'];
load(filters);

classes = ["04444","04519","02463","04338","04629","04715","04765","04822","04869","04905","04200","04339","04446","04530","04631","04716","04767","04823","04870","04906","04201","04341","04447","04531","04632","04719","04768","04827","04871","04907","04202","04343","04449","04535","04633","04720","04770","04829","04872","04908","04203","04344","04451","04537","04634","04721","04772","04830","04873","04909","04213","04347","04453","04542","04641","04722","04773","04831","04874","04910","04214","04349","04456","04553","04644","04724","04774","04832","04875","04911","04217","04350","04459","04556","04647","04725","04775","04833","04876","04912","04221","04351","04460","04557","04653","04726","04776","04838","04877","04913","04225","04361","04461","04560","04662","04727","04777","04839","04878","04914","04233","04370","04463","04569","04664","04728","04778","04840","04879","04915","04239","04372","04470","04575","04667","04729","04780","04841","04880","04916","04261","04378","04471","04577","04670","04730","04782","04842","04881","04917","04265","04379","04472","04578","04673","04731","04783","04843","04882","04918","04267","04382","04473","04580","04675","04732","04784","04846","04883","04919","04273","04385","04475","04581","04681","04733","04785","04847","04884","04920","04284","04387","04476","04585","04682","04734","04786","04848","04885","04921","04285","04388","04477","04587","04683","04736","04787","04849","04886","04922","04286","04394","04479","04588","04684","04737","04790","04850","04887","04923","04288","04395","04481","04589","04687","04738","04792","04851","04888","04924","04297","04397","04482","04593","04689","04742","04794","04853","04889","04925","04300","04400","04485","04595","04691","04743","04796","04854","04890","04926","04301","04404","04488","04596","04692","04744","04797","04855","04891","04927","04302","04407","04493","04597","04693","04745","04798","04856","04892","04928","04309","04408","04495","04598","04695","04746","04801","04857","04893","04929","04311","04409","04496","04600","04697","04747","04802","04858","04894","04930","04312","04418","04502","04603","04699","04748","04803","04859","04895","04931","04313","04419","04504","04605","04701","04749","04806","04860","04896","04932","04314","04423","04505","04609","04702","04751","04810","04861","04897","04933","04319","04427","04506","04612","04703","04754","04811","04862","04898","04934","04320","04429","04507","04613","04705","04756","04812","04863","04899","04935","04322","04430","04509","04615","04708","04757","04813","04864","04900","04936","04324","04434","04511","04621","04709","04758","04815","04865","04901","04327","04435","04512","04622","04711","04760","04816","04866","04902","04334","04436","04513","04626","04712","04762","04818","04867","04903","04336","04440","04514","04628","04714","04763","04821","04868","04904"];
cls=length(classes);

scores=[];

num = 5;


%% Load iris normalized images and the corresponding masks, and extract the binary codes
for f=1:cls

%     a = dir(strcat('/Users/nikitatripathi/Desktop/NDI-IRIS-DATA-NOTRE-DAME/Output/NormalizedImages/', c, '/*.bmp'));
%     num = size(a,1);
%     disp(['Starting with class ' c ' with ' num ' elements'])

    for s=f+1:cls
        for i=1:num
            im = imread(strcat('/Users/nikitatripathi/Desktop/NDI-IRIS-DATA-NOTRE-DAME/Output/NormalizedImages/', classes(f), '/', num2str(i), '_imno.bmp'));
            codesF(:,:,:,i) = extractCode(im,ICAtextureFilters);
            masksF(:,:,i) = imread(strcat('/Users/nikitatripathi/Desktop/NDI-IRIS-DATA-NOTRE-DAME/Output/NormalizedMasks/', classes(f), '/', num2str(i), '_mano.bmp'));
        end
        for i=1:num
            im = imread(strcat('/Users/nikitatripathi/Desktop/NDI-IRIS-DATA-NOTRE-DAME/Output/NormalizedImages/', classes(s), '/', num2str(i), '_imno.bmp'));
            codesS(:,:,:,i) = extractCode(im,ICAtextureFilters);
            masksS(:,:,i) = imread(strcat('/Users/nikitatripathi/Desktop/NDI-IRIS-DATA-NOTRE-DAME/Output/NormalizedMasks/', classes(s), '/', num2str(i), '_mano.bmp'));
        end

        for f1=1:num
            for s1=1:num
                scores = [scores matchCodes(codesF(:,:,:,f1), codesS(:,:,:,s1), masksF(:,:,f1), masksS(:,:,s1), l);];
            end
        end


    end

end

writematrix(scores, strcat("All_Inter_results/5_sample_results.csv"));