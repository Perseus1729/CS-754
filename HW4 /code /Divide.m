function [f1_actual,f2_actual]=Divide(f,A1,A2,t)
    theta2=randn(256,1);
    f2_actual=A2*theta2;
    diff=10;
    prev_error=0;
    epsilon=1e-3;
    while diff> epsilon        
        % f1_actual
        y=f-f2_actual;
        theta1=OMP(y,A1,t);
        f1_actual=A1*theta1;
        
        % f2_actual 
        y=f-f1_actual;
        theta2=OMP(y,A2,t);
        f2_actual=A2*theta2;
        
        error=norm(y-(f1_actual+f2_actual));
        diff=abs(prev_error-error);
        prev_error=error;
    end
end