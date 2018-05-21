function subject = compute_score(subject)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Computes the performance scores for a subject
    %
    % Parameters:
    % ----------------
    % SUBJECT       {struct} with fields responses, cues (minimal
    %                   requirements)
    %
    % Returns:
    % ---------------
    % SCORES        {struct) contains additionally a field scores (double 
    %                   of size 2x2)with rows for blocks (neutral, 
    %                   aversive) and columns the different metrics
    
    load('data/metadata.mat');
    subject.scores = zeros(2,2);
    
    % Blank performance score (in how many trials the guess was identical
    % to the stimulus -> ignoring 50% parts etc.)
    subject.scores(1,1) = sum(subject.responses(1,:)' == metadata.stimuli) / ...
        length(metadata.stimuli);
    subject.scores(2,1) = sum(subject.responses(2,:)' == metadata.stimuli) / ...
        length(metadata.stimuli);
    
    % Adjusted performance score. Ground truth is NOT the actual stimulus
    % (sound / no sound) but what an observer who, at any point in time, 
    % knows the underlying probability distribution would have guessed.(
    % That means, we exclude the third segment, because the prob. is 0.5
    
    tpd = metadata.trials_per_pd;
    resp = [subject.responses(:,1:2*tpd) subject.responses(:,3*tpd+1:end)]';
    gt = [metadata.cues(1:tpd); ~metadata.cues(tpd+1:2*tpd); ...
        metadata.cues(3*tpd+1:4*tpd); ~metadata.cues(4*tpd+1:5*tpd)];
    subject.scores(1,2) = sum(gt==resp(:,1))/length(resp);
    subject.scores(2,2) = sum(gt==resp(:,2))/length(resp);


end
