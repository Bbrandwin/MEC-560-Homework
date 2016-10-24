x = 0:.1:10;
y = 0:.1:10;

x_agent = [1];
y_agent = [1];

Act = zeros(length(x),length(y));
V = zeros(length(x),length(y));

[xx,yy] = meshgrid(x,y);

figure;
plot(xx,yy,'k.')
hold on;
x_goal = 9;
y_goal = 9;


x_start = 0;
y_start = 0;

[i_x,i_y]= xy_to_indices(x_goal,y_goal);
ix_goal = i_x;
iy_goal = i_y;

i_do_nth = [i_x,i_y];

Act(i_x,i_y) = 0;
plot(x_agent(1),y_agent(1),'go','MarkerFaceColor','green')
text(x_agent(1)-.4,y_agent(1)-.4,'start','Color','black','FontSize',22)
plot(x_goal,y_goal,'ro','MarkerFaceColor','red')
text(x_goal-.4,y_goal-.4,'goal','Color','black','FontSize',22)



obs_locs(1,:) = Wall(2,0,4,'up');
obs_locs(2,:) = Wall(2,2,1.5,'left');
obs_locs(3,:) = Wall(0,1,.5,'right');
obs_locs(4,:) = Wall(.5,2,5,'up');
obs_locs(5,:) = Wall(2,4,.5,'left');
obs_locs(6,:) = Wall(1.5,4,1.5,'up');
obs_locs(7,:) = Wall(.5,8,1.5,'up');
obs_locs(8,:) = Wall(.5,9.5,4,'right');
obs_locs(9,:) = Wall(4.5,9.5,2,'down');
obs_locs(10,:) = Wall(4.5,7.5,2.5,'left');

obs_locs(11,:) = Wall(3.5,8.5,2.25,'left');
obs_locs(12,:) = Wall(1.25,8.5,2,'down');
obs_locs(13,:) = Wall(1.25,6.5,6.25,'right');
obs_locs(14,:) = Wall(7.5,10,5,'down');
obs_locs(15,:) = Wall(9,5,6,'left');
obs_locs(16,:) = Wall(6,10,2,'down');
obs_locs(17,:) = Wall(3,5,4,'down');
obs_locs(18,:) = Wall(3,1,3,'right');
obs_locs(19,:) = Wall(7,0,4,'up');
obs_locs(20,:) = Wall(8,1,4,'up');
obs_locs(21,:) = Wall(7,3,2,'left');
obs_locs(22,:) = Wall(8,1,1,'right');
obs_locs(23,:) = Wall(10,3,1,'left');
obs_locs(24,:) = Wall(10,7,1.5,'left');
obs_locs(25,:) = Wall(8.5,7,2.25,'up');



buffer_zone = 0.2;

obs_locs_b = make_buffer_Obstacle(obs_locs,buffer_zone);



for i = 1:size(obs_locs,1)
    patch( [obs_locs(i,1) obs_locs(i,1)  obs_locs(i,3) obs_locs(i,3)  ], ...
        [obs_locs(i,2) obs_locs(i,4)  obs_locs(i,4) obs_locs(i,2)  ],'black' );
    
    [ix_obs_st,iy_obs_st]= xy_to_indices( obs_locs_b(i,1), obs_locs_b(i,2));
    [ix_obs_en,iy_obs_en]= xy_to_indices( obs_locs_b(i,3), obs_locs_b(i,4));
    
    Act(ix_obs_st:ix_obs_en,iy_obs_st:iy_obs_en) =  1000;
end