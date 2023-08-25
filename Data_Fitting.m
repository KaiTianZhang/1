clear all;close all;% data pasted from spreadsheetd=[0	0.000	0.000	0.000	0	0	0	0	0	0.000	0.000	0.0000.3	0.000	0.000	0.000	0	0	0	0	0	0.000	0.000	0.0000.7	0.000	0.000	0.000	0	0	0	0	0	0.000	0.000	0.0002.2	0.000	0.000	0.000	0	0	0	0	0	0.000	0.000	0.0003.8	0.000	0.000	0.000	0	0	0	0	0	0.000	0.000	0.0005.4	0.000	0.000	0.000	0.000	0	0.363196126	0	0	1.162	1.332	1.1627	0.000	1.356	1.162	1.162	1.065375303	1.113801453	1.331719128	1.162227603	1.404	2.058	2.0588.6	0.605	0.969	1.598	1.598	1.598062954	2.05811138	1.719128329	1.840193705	1.840	2.034	2.25210.2	1.186	1.598	1.695	1.695	2.05811138	2.082324455	2.05811138	1.86440678	1.598	3.632	5.23011.8	1.162	1.816	1.816	1.816	2.469733656	2.033898305	1.86440678	2.300242131	2.349	3.680	4.11613.5	1.429	1.816	1.864	1.864	2.276029056	2.300242131	2.082324455	2.518159806	2.518	4.092	4.79415.2	1.622	2.107	2.736	2.736	2.784503632	2.711864407	2.784503632	2.493946731	3.414	4.116	4.98816.8	1.598	2.542	2.954	2.954	3.171912833	2.736077482	2.736077482	2.736077482	3.898	4.310	6.12618.5	1.840	2.300	2.978	2.978	2.953995157	3.196125908	2.978208232	3.244552058	4.334	4.770	6.10220.2	1.622	2.736	3.874	3.874	3.849878935	3.244552058	2.978208232	3.898305085	3.414	4.988	7.62721.9	1.864	3.196	3.414	3.414	2.518159806	3.631961259	3.631961259	3.898305085	4.552	4.988	6.15023.5	2.300	3.196	3.390	3.390	3.414043584	4.939467312	2.978208232	4.527845036	4.140	5.908	6.53825.3	2.082	2.736	3.826	3.826	3.414043584	4.11622276	3.414043584	4.987893462	4.794	4.988	6.58627.1	2.082	3.438	3.656	3.656	4.309927361	4.455205811	3.849878935	4.06779661	5.012	5.472	6.15029	2.300	3.220	4.770	4.770	4.552058111	4.552058111	4.334140436	4.309927361	5.424	5.472	5.64230.5	4.552	3.172	4.092	4.092	4.697336562	4.818401937	4.963680387	3.849878935	5.690	6.102	6.610];x=d(:,1)';P=x; % power values [W]dwell_s=[3 5 7 7 7 7 7 7 10 15 20]; % sdwell=[]; % data used to be filled laterPlim=dwell-dwell; % threshold power to be filled laterdiam=[]; % diameter values to be filled later% loop over data for each duration time experiment (columns of spreadsheet)for j=2:length(d(1,:));  % take next dataset from array  y=d(:,j)';dwell=[dwell dwell_s(j-1)];diam=[diam; y];  % plot experimental data on new figure    figure;plot(x, y, 'k.',x, y, 'ko');title(disp(num2str(j-1)));hold on;drawnow    %Define the  model for minimization (least squares):  % our model: model_y=real(sqrt(x-p(1)).*p(2)) with p(1) & p(2) for fitting  % for fitting we minimize the sum of the squares of the differences of   % experimental and model values:  my_fun = @(p) sum((y-  real(sqrt(x-p(1)).*p(2)) ).^2);     %Inital guesses  p0 = [5.5,.46];     %Nonlinear fit to improve on the initial guess p0; extract threshold "th"  result = fminsearch(my_fun, p0); th=result(1); mf=result(2);    % new x values for evaluating the model  xf=[min(x):.005*range(x):max(x)];  %Function to evaluate the model  fun_eval = @(p, t) real(sqrt(t-p(1))).*p(2);    % outputting the threshold value "result(1)" (P_lim)  disp([num2str(j-1) ': Dwell = ' num2str(dwell_s(j-1)) ' s; threshold = ' num2str(th,4) ' W; mult.-factor = ' num2str(mf,4) ' mm/sqrt(W)'])    % add a plot of the result of fitting   yf=fun_eval(result, xf); plot(xf, yf, 'r',xf, yf, 'k.', [th th],[min(yf) max(yf)]);  title(['Dwell = ' num2str(dwell_s(j-1)) ' s, Fit:  y = ' num2str(result(2),4) '*sqrt(x - ' num2str(th,4) ')   '])  xlabel('Power [W]');ylabel('Diameter [mm]'); Plim(j-1)=result(1);  text(th,max(yf),[num2str(th) 'W'])end% visualize threshold dataz=dwell;figure ; [C,h] =contourf(P,z,diam,[min(min(diam)):max(max(diam))]);clabel(C,h); hold on;title(['Diameter [mm]']);xlabel('Power [W]'); ylabel('Dwell Time [s]')plot(Plim,dwell,'g',Plim,dwell,'gs');hold onfor j=1:length(x);  for k=1:length(z); plot(x(j),z(k),'ro'); end end print -dpng contplot_Kai.png;%%%%% end of code