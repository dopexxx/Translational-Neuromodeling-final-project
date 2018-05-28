function mu_k = alpha_model(alpha, x, pi_prior, pi_llh, mu_pri)

    

   n = length(x);
   
   mu_k = zeros(n+1,1);
   mu_k(1) = mu_pri;
   
   pi_post = zeros(n+1,1);
   pi_post(1) = pi_prior;
   
   for k = 2:n+1
       pi_post(k) = pi_prior + alpha*pi_llh;
       mu_k(k) = mu_k(k-1) + (1/pi_post(k)) * (x(k-1) - mu_k(k-1));
   end
   
   mu_k(1)=[];

    
end 