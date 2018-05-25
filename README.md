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
    



- Noch 3 subjects recorden -> MO
- Reject subjects - Function that reject subject according to some definition. Mehr als 10% NaNs, speichert subject als rejected. - JANNIS
- Questionnaire auswerten - MO 
    - Performance korrelieren mit subjektiver Performance und how do you feel today?
    - Angst korrelieren mit Differenz der HGF parameter für neutrales und aversives Setup


- Alpha Fitting - LUKE
    - Fit alphas 
    - Relation zu omega2 (korrelieren)
    - Falls gute Ergebnisse - BMS Alpha Model vs 2 HGFs


- Massage HGF Parameter         MO
    -   How to change and fix parameter? Config files?         
    -   Focus on Omega2 -> Omega 2 viel Varianz geben-> Wo liegt die Parallele zu Lukes alpha und TWI
    -   Omega 3 fixen -> prior mit kleiner variance
    -   Mit und ohne omega3, brauchen wir das 3. Layer? Set Omega = 1 to get rid of third layer or use a 2_layer_binary_config file?
    -   Precision hoch für Zeta und absoluten Wert auch höher damit weniger decision noise -> 
    -   Model evidences vergleichen aka Bayes factor (2 vs 3 Layer)

- Biased Reponse Model
    -   Herausfinden wie fitting geht - TNU fragen
    -   Definition and 
    -   NOT weil bias im contingency space

- Science Paper von Christoph (Kappa1 oder welcher?) coupling   

- RFX Analyse angucken      JANNIS
    - Random Effects Analysis für Omega2 von neutral und sound blöcken und vergleichen mit der RFX von den alphas. 


- GSR 
    - Daten für HGF vorbereiten     JANNIS
        - Filtern, binärisieren und mean pro post stimulus time berechnen
        - timings
    - PSTH
    - Mean responses für neutral und aversiv


Geld stuff regeln
DEMO inspiration


