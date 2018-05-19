# TNM_project
Code for the final project in the TNM course

List of problems:

1) SCR MO
    - buy components and build circuit and test
    - write matlab readin/readout function
    - fix synchronization problem of matlab instances
    
2) Experimental design
    A. Theory
        - choose sequence (experimental paradigm)
        - choose cues:
            Square and circle (black)
        - choose stimuli: neutral simulus, sine wave w/ envelope
        - choose iter-trial-intervals
             ITI 1000ms +- 500ms,
        - choose probability structure of cue-stimulus contingency
            -> Take from Iglesias(2013): [0.9, 0.1, 0.5, 0.7, 0.3, 0.9, 0.3, 0.7, 0.5, 0.1]
            On average one cue-stimulus-probabilty for 20 trials, sample uniformly to have ranges in [15,25]
            Cheat for last one to make it 150 trials -> insgesamt ca.
                Visual cues (colored dots)
                Sample once for every trail whether cue A or cue B is shown (coin flipping)
                Sample targets once from the cue-stimulus probability distributions

        - take same sequence prob dist ([0.9, 0.1, 0.5, 0.7, 0.3, 0.9, 0.3, 0.7, 0.5, 0.1]) for neutral and aversive stimuli
        



    B. Practice
        - code GUI for experimental procedure (COGENT ?) JANNIS
        - test it on ourselves!!! (including analysis?)


    C. Design behavioral questionnaire with 3 questions: 
        - How concentrated do you feel today? (Scale from 0 to 10)
        - How quickly do you get nervous or anxious in everyday situations (0 to 10)
        - AFTER experiment: How well did you think you solved the task? (falten)
        - PRINT out the questionnaires with individual ID 
        -   Add line of code to read in participant ID
    
3) Run the experiment
    A. Recruit participants
        - find incentives (money)
        - Tell people that cue-stimulus-prediction-probability changes over time (also tell boundaries)
    B. Run experiment
    C. Reward participants

4) Analysis pipeline LUKAS
    i. HGF: basic analysis (posterior expectation)
        - think up pipeline for analysis 
            + which HGFs are fitted
            + which parameters are compared and HOW
            + understand theory behind RFX analysis and write down how 
              we would apply it to our data, concretely (inputs)
        - SCR
            + postprocess data (filtering, synchronizing, etc.)
            + how to incorporate it
            + binarize SCR data and repeat HGF analysis
            + cross-modality correlation
    ii. HGF: fancy analysis (biased response model)
        - code up response model of variable bias
        - simulate some data and scrutinize it
        
5) Presentation
    - assign subtasks
    - think about marketing
    - wrap things up inside a coherent story
    - make nice plots
    
6) Report
    - find out when it's due


