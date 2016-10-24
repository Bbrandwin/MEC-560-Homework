xy_all = [x_all y_all];
newPath = xy_all;
newPath(1,:) = xy_all(1,:);
newPath(end,:)=xy_all(end,:);

for i_iter = 1:5000
    for i = 2:length(xy_all)-1
        newPath(i,:) = newPath(i,:)+ .5*(xy_all(i,:)- newPath(i,:))+ 0.5*(newPath(i-1,:)-2*newPath(i,:)+newPath(i+1,:));
    end
end
j(3) = plot(newPath(:,1),newPath(:,2), 'red');
legend(j([2 3]),{'Shortest Path', 'Curved Path'})
title('Path Generation')

[pX, pY, t_track] = generateSpline(newPath, 1.5);