# TNM_project
Code for the final project in the TNM course

The current report is under (tex file + bib file):
https://www.overleaf.com/16688233mcmbvnbfrpvc#/63995849/ 

TODO: Finish the report. That means:


1) Summarize what we already did:
    1) Intro section
        a) Expand the 3 questions we raised into a computational assay
            - Does nature of stimuli affect the size of temporal integration windows?
        b) Mentioning of alpha model in intro section? At least as an instructive re-interpretation of established HGF parameters?
    2) Method section
        a) Describe experiment
        b) Describe HGF pipeline 
            - 100x rerunning the HGF models -> report variances in params and make a point that there is no point in rerunning (but we are aware...)
            - Which HGFs (2-layer, 3-layer, initial fits with default params or omega3 fix and omega2 with high prior?)
            - How and why which parameters of the HGF are compared
        c) Describe GSR pipeline (preprocessing Ledalab, synchronizing)
    3) Paste all plots from presentation into report and add descriptions.
    4) Paste questionnaire results into Appendix 




2) Perform further analysis
    a) HGF 
        - LME of 2 layer vs 3 layer HGF (if valid) and of neutral vs aversive models
        - RFX analysis of HGF parameter sets for neutral vs aversive fits
        - Science Paper von Christoph Mathys, neue Interpretation von Kappa1 angucken und was sagt uns das?  
    b) GSR: Create binarized data based on canonical PE signal, compare to behavioral HGF fits (cross modal parameter correlation and other comparisons, e.g. RFX?)
        - Bayes Factors to behaviroal HGFs
        - Korrelation von prediction error trace und prediction error aus GSR -> almost no correlation 
        - Korrelation of PE trace (50% of trials with highest signal have PE) with performance vector -> almost no correlation
        -> 3 bins fur prediction error intensity und dann jeweils die responses plotten -> Mindestens subject 13 in presentation
        -> Scores berechnen von gsr_resp
    c) Biased response model?
        -   NOT weil bias im contingency space
    d) Alpha Analysis:
        - Relation between alpha in RW and alpha alpha
        - Quantitative comparison between alpha and omega2
        - runtime of Alpha Model vs runtime of HGF
        - Qualitative comparison of Alpha and HGF 2 layer and RM Model
            - RM cannot be bayes optimal, alpha and HGF can, how do the equation from 2 layer HGF and alpha differ?
        - Alpha fitting: Compute 2nd derivatives in order to discard local maxima
    e) Questionnaire:
        - Correlate obj. and subj. perf.
        - Correlate angst with diff in parameter in neutral and aversive


3) Agree on discussion, interpretation and abstract

4) Clean up code (discard, merge methods, simplify redoing of analysis)

