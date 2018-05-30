# TNM_project
Code for the final project in the TNM course

List of problems:

4) Analysis pipeline LUKAS
    MORITZ LAPTOP HAS 35ms DELAY to JANNIS!! -> Hard code in timestamps!
    i. HGF: basic analysis (posterior expectation)
        - think up pipeline for analysis 
            + which HGFs are fitted
            + which parameters are compared and HOW
            + understand theory behind RFX analysis and write down how we would apply it to our data, concretely (inputs)
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

    1)  Intro & Motivation -> Computational ASSAY           MO
            - Blurry border between healthy and pathologic symptoms
            - Need models to quantify that
            - Was wir uns angucken
                - Autonomoic correlates of prediction error 
                - Do aversive vs neutral stimuli induce atypical behavior? If people react highly sensititve to negative stimuli, it may pathological?
                - Can the degree to which negative stimuli biases behavior be used as a diagnostic tool, i.e. as a computational essay to recognize symptoms and predispositions.
                - Placeholder für AlphaModel   
    2)  Experiment erklären + Video         Jannis
            - "not so loosely based on"  Sandra, shorter etc. -> HGF 
            - Video und Overview slide (sandra)
            - GSR recorded
            - Analysis pipeline (Flowchart ) und perf plot
    3)  HGF Model           Mo + Luke
            - These are the equations
            - These are the models we use (perceptual etc.)
            - These are the parameter we fit
            - Here are the results (neutral vs aversive)
            - Answers to questions raised in Intro
            - Vergleich vorher nachher performance (degree of Bayesian optimality with our metric, e.g. squared residuals), Omega, Kappa
    4)  GSR Model       Jannis
        - prediction error theory
        - mean stimulus specific response for neutral vs aversive sound

    5)  Alpha Model         Luke
            - GSR results not so meaningful, behavior results soso, we have another motivation, i.e. do aversive stimuli affect the size of the temporal window of integration?
            - Verbindung zur Motivation ->
    6)  Summary & Conclusion -> Translational outlook
    


- Questionnaire auswerten - MO 
    - Performance korrelieren mit subjektiver Performance und how do you feel today?
    - Angst korrelieren mit Differenz der HGF parameter für neutrales und aversives Setu


- Alpha Fitting - LUKE
    - Fit alphas 
    - Relation zu omega2 (korrelieren)
    - Falls gute Ergebnisse - BMS Alpha Model vs 2 HGFs
    - Compute runtimes
    - Equality to 2 level HGF??


- Massage HGF Parameter         MO
    -   How to change and fix parameter? Config files?         
    -   Focus on Omega2 -> Omega 2 viel Varianz geben-> Wo liegt die Parallele zu Lukes alpha und TWI
    -   Omega 3 fixen -> prior mit kleiner variance
    -   Mit und ohne omega3, brauchen wir das 3. Layer? Set Omega = 1 to get rid of third layer or use a 2_layer_binary_config file?
    -   Precision hoch für Zeta und absoluten Wert auch höher damit weniger decision noise -> 
    -   Model evidences vergleichen aka Bayes factor (2 vs 3 Layer)
    -   Kappa_1

- Biased Reponse Model
    -   Herausfinden wie fitting geht - TNU fragen
    -   Definition and 
    -   NOT weil bias im contingency space

- Science Paper von Christoph (Kappa1 oder welcher?) coupling   

- RFX Analyse angucken      JANNIS
    - Random Effects Analysis für Omega2 von neutral und sound blöcken und vergleichen mit der RFX von den alphas. 


- GSR                       JANNIS
    - Korrelation von prediction error trace und prediction error aus GSR -> almost no correlation 
    - Korrelation of PE trace (50% of trials with highest signal have PE) with performance vector -> almost no correlation
    - Mean Plots: Plot wrong trials vs correct trials

    -> 3 bins fur prediction error intensity und dann jeweils die responses plotten
    -> Scores berechnen von gsr_resp
    -> Andere mean plots berechnen

Idea:Maybe responses backwards inferred from the prediction error encoded in the GSR signal give rise to a more accurate/less volatile/more BO/anyhow different HGF.

Alpha Model - Model inversion:
- Inverted the model to find the generative model that best explains the data
- Show derivation
- Did not find an analytical expression for alpha yet, since the mus and pis are vectors which are updated iteratively in the forward model and our math is not solid enough to find an analytical expression (if one exists)
- But we use this equation to compute the gradient to fit the alphas. So far most of the error surfaces we looked at were convex, but some were not and then of course this method has all the drawbacks accompagnied by methods that find local instead of global minima
- Plot error vs gradient and show error surface dependent also on the prior
--> Slide machen. Alternative optimization methods open for ideas.


DEMO inspiration 

NEWTON RAPHSON METHOD

