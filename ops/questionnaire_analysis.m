%% Questionnaire analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
quest.questions = cell(3,1);
quest.questions{1} = 'How do you feel today?'
quest.questions{2} = ['In general, how easily do you become nervous or' ...
                      'anxious in everyday life?'];
quest.questions{3} = 'How well do you believe you performed the task?'

quest.resp = zeros(20,3);

%% Automated input
cont = 1
while cont
    id = input('ID')
    quest.resp(id,1) = input('Q1: ')
    quest.resp(id,2) = input('Q2: ')
    quest.resp(id,3) = input('Q3: ')   
    cont = input('Continue?')
end
%% Add IDs
quest.resp = [[1:20]' quest.resp]
%% Check which ones are usable (remove all zeros and nans)
available = sum(quest.resp(:,2:end),2)==0;
available = logical(~available .* ~any(isnan(quest.resp),2));
usable = quest.resp(available,:);
%% Plotting 1: Various correlations within questionnaire data
corr(usable)

figure
subplot(121)
scatter(usable(:,3),usable(:,4))
xlabel('How easily do you become nervous/anxious?')
ylabel('How well do you think you performed?')
axis([0 10 0 10])

subplot(122)
scatter(usable(:,2),usable(:,4))
xlabel('How well do you feel today?')
ylabel('How well do you think you performed?')
axis([0 10 0 10])

figure
scatter(usable(:,1),usable(:,2))
ylabel('How well do you feel today?')
xlabel('Subject ID','fontsize',20)
hold on
plot(x,y)
text(2,4,'\rho = - 0.7','interpreter','tex','fontsize',15)
coeffs = polyfit(usable(:,1),usable(:,2),1);
x = 0:0.01:15;
y = polyval(coeffs,x);

%% Plotting 2: Correlations between subjective and actual performance

scores = zeros(20,3);
scores = [[1:20]' scores];
% get actual performance
for i = 1:16
    try
        load(['subject_',num2str(i),'.mat'])
        scores(i,2)=subject.stats.total_score_neutral;
        scores(i,3)=subject.stats.total_score_aversive;
        scores(i,4)=0.5*(scores(i,2)+scores(i,3));   
    catch 
        fprintf('\nSubject %d not found',i)
        available(i)=0;
    end
end

usable_resp = quest.resp(available,2:4)
usable_scores = scores(available,4) % only look at mean score

data = [usable_resp usable_scores]
corr(data)



