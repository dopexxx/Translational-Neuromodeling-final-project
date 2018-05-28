function alpha_traj = simulate_learning(input_seq, prior_prec, prior_mean, alpha)
    alpha_traj = [prior_mean]; 
    prec = prior_prec;
    for cumulative = 1:length(input_seq)
        prec = prec + alpha; 
        new = alpha_traj(1) + 1/prec * (input_seq(cumulative)-alpha_traj(1));
        alpha_traj = [new alpha_traj];
    end
    alpha_traj = fliplr(alpha_traj);
    alpha_traj = alpha_traj(2:end);
end