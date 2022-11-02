function avg_min_entropy = subsampleCalc(k)
    %SUBSAMPLECALC Takes k (number of bits) as input and outputs the
    %average min-entropy for a subsample of this size
    
    %   Detailed explanation goes here: TODO
    
    disp(["Starting with" num2str(k) "-bit samples"])
    
    
    %% Load the selected domain-specific filter set
    l = 15;     % size of the filer
    n = 7;      % number of kernels in a set
    filters = ['../iris_sourced_filters/new_bsif_filters_based_on_eyetracker_data/ICAtextureFilters_' num2str(l) 'x' num2str(l) '_' num2str(n) 'bit.mat'];
    load(filters);
    
    classes = ["04444","04519","02463","04338","04629","04715","04765","04822","04869","04905","04200","04339","04446","04530","04631","04716","04767","04823","04870","04906","04201","04341","04447","04531","04632","04719","04768","04827","04871","04907","04202","04343","04449","04535","04633","04720","04770","04829","04872","04908","04203","04344","04451","04537","04634","04721","04772","04830","04873","04909","04213","04347","04453","04542","04641","04722","04773","04831","04874","04910","04214","04349","04456","04553","04644","04724","04774","04832","04875","04911","04217","04350","04459","04556","04647","04725","04775","04833","04876","04912","04221","04351","04460","04557","04653","04726","04776","04838","04877","04913","04225","04361","04461","04560","04662","04727","04777","04839","04878","04914","04233","04370","04463","04569","04664","04728","04778","04840","04879","04915","04239","04372","04470","04575","04667","04729","04780","04841","04880","04916","04261","04378","04471","04577","04670","04730","04782","04842","04881","04917","04265","04379","04472","04578","04673","04731","04783","04843","04882","04918","04267","04382","04473","04580","04675","04732","04784","04846","04883","04919","04273","04385","04475","04581","04681","04733","04785","04847","04884","04920","04284","04387","04476","04585","04682","04734","04786","04848","04885","04921","04285","04388","04477","04587","04683","04736","04787","04849","04886","04922","04286","04394","04479","04588","04684","04737","04790","04850","04887","04923","04288","04395","04481","04589","04687","04738","04792","04851","04888","04924","04297","04397","04482","04593","04689","04742","04794","04853","04889","04925","04300","04400","04485","04595","04691","04743","04796","04854","04890","04926","04301","04404","04488","04596","04692","04744","04797","04855","04891","04927","04302","04407","04493","04597","04693","04745","04798","04856","04892","04928","04309","04408","04495","04598","04695","04746","04801","04857","04893","04929","04311","04409","04496","04600","04697","04747","04802","04858","04894","04930","04312","04418","04502","04603","04699","04748","04803","04859","04895","04931","04313","04419","04504","04605","04701","04749","04806","04860","04896","04932","04314","04423","04505","04609","04702","04751","04810","04861","04897","04933","04319","04427","04506","04612","04703","04754","04811","04862","04898","04934","04320","04429","04507","04613","04705","04756","04812","04863","04899","04935","04322","04430","04509","04615","04708","04757","04813","04864","04900","04936","04324","04434","04511","04621","04709","04758","04815","04865","04901","04327","04435","04512","04622","04711","04760","04816","04866","04902","04334","04436","04513","04626","04712","04762","04818","04867","04903","04336","04440","04514","04628","04714","04763","04821","04868","04904"];
    cls=length(classes);
    

    trials = 10; % number of trials
    
    num = 4; % number of samples per class (used to be 5)
    
    pos = 1; % position in scores (used to index)
    old_pos = 0; % last displayed position (used for progress tracking)
    scores = zeros(10,1011040); % preallocating space - store comparison scores (one row per trial)


    % preallocating space - store codes and masks to compare
    codesF = zeros(64, 512, 7, 4);
    codesS = zeros(64, 512, 7, 4);
    masksF = zeros(64, 512, 4);
    masksS = zeros(64, 512, 4);



    %% Load iris normalized images and the corresponding masks, and extract the binary codes
    for f=1:cls
    
        for s=f+1:cls
            for i=1:num
                im = imread(strcat('/Users/nikitatripathi/Desktop/NDI-IRIS-DATA-NOTRE-DAME/Output/NormalizedImages/', classes(f), '/', num2str(i), '_imno.bmp'));
                codesF(:,:,:,i) = extractCode(im,ICAtextureFilters);
                masksF(:,:,i) = imread(strcat('/Users/nikitatripathi/Desktop/NDI-IRIS-DATA-NOTRE-DAME/Output/NormalizedMasks/', classes(f), '/', num2str(i), '_mano.bmp'));

                im = imread(strcat('/Users/nikitatripathi/Desktop/NDI-IRIS-DATA-NOTRE-DAME/Output/NormalizedImages/', classes(s), '/', num2str(i), '_imno.bmp'));
                codesS(:,:,:,i) = extractCode(im,ICAtextureFilters);
                masksS(:,:,i) = imread(strcat('/Users/nikitatripathi/Desktop/NDI-IRIS-DATA-NOTRE-DAME/Output/NormalizedMasks/', classes(s), '/', num2str(i), '_mano.bmp'));
            end

            % Generate 10 x k random positions (for 10 trials)
            positionsX = randi([1 64], 10, k);
            positionsY = randi([1 512], 10, k);
            positionsZ = randi([1 7], 10, 1);

            % Make subsamples at these positions and calculate distance
            for f1=1:num
                for s1=1:num
                    % Grab all codes
                    cF = codesF(:,:,:,f1);
                    cS = codesS(:,:,:,s1);
                    mF = masksF(:,:,f1);
                    mS = masksS(:,:,s1);
                    % Make subsamples and match (for 10 trials)
                    parfor t=1:trials
                        scores(t, pos) = matchCodes(cF(positionsX(t, :), positionsY(t, :), positionsZ(t, :)), cS(positionsX(t, :), positionsY(t, :), positionsZ(t, :)), mF(positionsX(t, :), positionsY(t, :)), mS(positionsX(t, :), positionsY(t, :)), l);
                    end
                    pos = pos+1;

                end
            end

        end
        if (pos-old_pos)/10000 > 1
            old_pos = pos;
            disp([k pos])
        end
    end


    trial_entropies = zeros(1, 10);
    for t=1:trials
        % Trial are complete here. Now we compute mean and
        % variance of the scores in this trial
        mu = mean(scores(t,:));
        sigma = std(scores(t,:))^2;

        % We can now estimate the subsample entropy using Fullers
        % method
        dF = mu * (1-mu)/sigma;
        entropy = (-mu * log2(mu) - (1-mu) * log2(1-mu)) * dF;

        % This estimate is stored in trial_entropies array and
        % scores is reset to empty for the upcoming trial
        trial_entropies(t) = 2^(-entropy);
    end




    % 10 trials for a particular k have been completed. Now we
    % compute the overall entropy for subsample size k
    avg_min_entropy = - log2(mean(trial_entropies));
    disp([k avg_min_entropy])

    % Save results to ./Subsample_Results
    filename = sprintf("Subsample_Results/%d_results", k);
    save(filename, 'scores');


end

