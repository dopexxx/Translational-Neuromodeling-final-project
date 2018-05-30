function subject = compute_score(varargin)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Computes the performance scores for a subject
    %
    % Parameters:
    % ----------------
    % SUBJECT       {struct} with fields responses, cues (minimal
    %                   requirements)
    % RESPONSES     {double} [2x150] iff length(varargin)==2, then the
    %                   responses in the struct are ignored
    %
    % Returns:
    % ---------------
    % SCORES        {struct, double}. Struct iff length(varargin)==1. Then
    %                   subject contains additionally a field "scores" (double 
    %                   of size 2x2) with rows for blocks (neutral, 
    %                   aversive) and columns the different metrics
    %
    %                   Iff length(varargin)==2 subject is a 2x2 double of
    %                   scores
    %
    %   May 2018, Jannis Born
    
    if length(varargin) == 1
        subject = varargin{1};
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
        
        
    elseif length(varargin) == 2
        subject = varargin{1};
        responses = varargin{2};
        load('data/metadata.mat');

        scores = zeros(2,2);
        
        % Blank performance score (in how many trials the guess was identical
        % to the stimulus -> ignoring 50% parts etc.)
        scores(1,1) = sum(responses(1,:)' == metadata.stimuli) / ...
            length(metadata.stimuli);
        scores(2,1) = sum(responses(2,:)' == metadata.stimuli) / ...
            length(metadata.stimuli);

        % Adjusted performance score. Ground truth is NOT the actual stimulus
        % (sound / no sound) but what an observer who, at any point in time, 
        % knows the underlying probability distribution would have guessed.(
        % That means, we exclude the third segment, because the prob. is 0.5

        tpd = metadata.trials_per_pd;
        % exclude random block in the middle
        resp = [responses(:,1:2*tpd) responses(:,3*tpd+1:end)]';
        gt = [metadata.cues(1:tpd); ~metadata.cues(tpd+1:2*tpd); ...
            metadata.cues(3*tpd+1:4*tpd); ~metadata.cues(4*tpd+1:5*tpd)];
        scores(1,2) = sum(gt==resp(:,1))/length(resp);
        scores(2,2) = sum(gt==resp(:,2))/length(resp);
        
        % To return properly
        subject = scores;
        
        
    else 
        error('Unspecified amount of input arguments.')
    end
        
    
    


end
