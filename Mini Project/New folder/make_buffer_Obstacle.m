function obs_locs_b = make_buffer_Obstacle(obs_locs,buf)

obs_locs_b = [max(0,obs_locs(:,1)-buf) max(0,obs_locs(:,2)-buf) ...
    min(10,obs_locs(:,3)+buf) min(10,obs_locs(:,4)+buf)  ];