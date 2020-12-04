// Patch file for b700ish -- b700ish runs this to set up the patch library
// Aaron Lanterman, October 21, 2020

~instruments = Array.new;
~instrumentNames = Array.new;

// initial patch
~instrumentNames = ~instrumentNames.add("Initial");
~instruments = ~instruments.add({
~gconfig = 1;
~goffsets = [0,0,10,0,0,10,0,0,10,0];
~gcf = 0.5;
~gwsAselect = 0; ~gwsBselect = 0;
~gnumerators = [1,1,1,1]; ~gdenominators = [1,1,1,1];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env([0],[1])";
~genvstr[~idx2eno] = "Env([0],[1])";
~genvstr[~idx3eno] = "Env([0],[1])";
~genvstr[~idx4eno] = "Env([0],[1])";
~genvstr[~idx5eno] = "Env([0],[1])";
~genvstr[~idx6eno] = "Env([0],[1])";
~genvstr[~levelAeno] = "Env.adsr(0,0,1,0,10,0)";
~genvstr[~levelBeno] = "Env.adsr(0,0,1,0,10,0)";
~genvstr[~filteno] = "Env([0],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});


// phased gong
~instrumentNames = ~instrumentNames.add("Phased Gong");
~instruments = ~instruments.add({
~gconfig = 1;
~goffsets = [0,0,0,0,0,0,0,0,0,0];
~gcf = 0.5;
~gwsAselect = 0; ~gwsBselect = 0;
~gnumerators = [1,3.5,1,3.5]; ~gdenominators = [1,1,2,2];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env([0,10,0],[0.147,20],[-10,1.5])";
~genvstr[~idx2eno] = "Env([0],[1])";
~genvstr[~idx3eno]= "Env([10],[1])";
~genvstr[~idx4eno] = "Env([10],[10])";
~genvstr[~idx5eno]  = "Env([0],[1])";
~genvstr[~idx6eno] = "Env([10],[1])";
~genvstr[~levelAeno] = "Env.adsr(0,0.038,1,1.5,10,0)";
~genvstr[~levelBeno] = "Env.adsr(0,0.592,0,0.873+0.592,10,1)";
~genvstr[~filteno] = "Env([10],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});

~instrumentNames = ~instrumentNames.add("80s Electric Piano");
~instruments = ~instruments.add({
~gconfig = 1;
~goffsets = [0,0,0,0,0,0,0,0,0,0];
~gcf = 0.5;
~gwsAselect = 0; ~gwsBselect = 0;
~gnumerators = [1,14,1,1]; ~gdenominators = [1,1,1,1];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env.adsr(0,5,0,0.1,4+(~vel*1.8),0)";
~genvstr[~idx2eno] = "Env([0],[1])";
~genvstr[~idx3eno] = "Env([10],[1])";
~genvstr[~idx4eno] = "Env.adsr(0,6,0,0.1,5+(~vel*2.5),0)";
~genvstr[~idx5eno] = "Env([0],[1])";
~genvstr[~idx6eno] = "Env([10],[1])";
~genvstr[~levelAeno]  = "Env.adsr(0,5,0,0.1,8+(~vel*2),0)";
~genvstr[~levelBeno]  = "Env.adsr(0,7,0.5,0.1,8+(~vel*2),0)";
~genvstr[~filteno] = "Env([10],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});

~instrumentNames = ~instrumentNames.add("Lately Bass");
~instruments = ~instruments.add({
~gconfig = 4;
~goffsets = [0,0,0,0,0,0,0,0,0,0];
~gcf = 0.5;
~gwsAselect = 0; ~gwsBselect = 0;
~gnumerators = [1,1,1,1]; ~gdenominators = [2,2,2,1];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env([0],[1])";
~genvstr[~idx2eno] = "Env.adsr(0,3,0,0.1,7.3,0)";
~genvstr[~idx3eno] = "Env([10],[1])";
~genvstr[~idx4eno] = "Env.adsr(0,0.1,0,0.1,7.5,0)";
~genvstr[~idx5eno]= "Env.adsr(0,3,0,0.1,8.1,0)";
~genvstr[~idx6eno] = "Env([10],[1])";
~genvstr[~levelAeno] = "Env.adsr(0,0,1,0.1,10,0)";
~genvstr[~levelBeno] = "Env.adsr(0,0,1,0.1,10,0)";
~genvstr[~filteno] = "Env([10],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});

~instrumentNames = ~instrumentNames.add("FB-01 Bass");
~instruments = ~instruments.add({
~gconfig = 6;
~goffsets = [0,0,0,0,0,0,0,0,0,0];
~gcf = 0.5;
~gwsAselect = 0; ~gwsBselect = 0;
~gnumerators = [1,1,3,0.5]; ~gdenominators = [2,2,2,2];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env.adsr(0,2,0,1,7.4+~vel*(1.1),0)";
~genvstr[~idx2eno] = "Env.adsr(0,4,0.75,1,5+(~vel*2.8),0)";
~genvstr[~idx3eno] = "Env([10],[1])";
~genvstr[~idx4eno] = "Env.adsr(0,7,0.8,1,5.9,0)";
~genvstr[~idx5eno]= "Env([0],[1])";
~genvstr[~idx6eno] = "Env([10],[1])";
~genvstr[~levelAeno] = "Env.adsr(0,10,1,1,10,0)";
~genvstr[~levelBeno] = "Env.adsr(0,10,1,1,10,0)";
~genvstr[~filteno] = "Env([10],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});


~instrumentNames = ~instrumentNames.add("ROM Bass 1");
~instruments = ~instruments.add({
~gconfig = 6;
~goffsets = [0,0,0,0,0,0,0,0,0,0];
~gcf = 0.5;
~gwsAselect = 0; ~gwsBselect = 0;
~gnumerators = [0.5,0.5,5,0.5]; ~gdenominators = [1,1,1,1];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env.adsr(0,1,0,1,4+(~vel*4.8),0)";
~genvstr[~idx2eno] = "Env.adsr(0,2,0,1,5.5+(~vel*1.5),0)";
~genvstr[~idx3eno] = "Env([10],[1])";
~genvstr[~idx4eno] = "Env.adsr(0,8,0,1,8.0,0)";
~genvstr[~idx5eno]= "Env([0],[1])";
~genvstr[~idx6eno] = "Env([10],[1])";
~genvstr[~levelAeno] = "Env.adsr(0,10,1,1,10,0)";
~genvstr[~levelBeno] = "Env.adsr(0,10,1,1,10,0)";
~genvstr[~filteno] = "Env([10],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});

~instrumentNames = ~instrumentNames.add("Experiment 1");
~instruments = ~instruments.add({
~gconfig = 1;
~goffsets = [0,0,0,0,0,0,0,0,0,0];
~gcf = 0.5;
~gwsAselect = 0; ~gwsBselect = 0;
~gnumerators = [1,1,1,1]; ~gdenominators = [1,3,1,1];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env([0,8.33,8.06,7],[1/6,1/6,2],[0,0,0])";
~genvstr[~idx2eno] = "Env([0],[1])";
~genvstr[~idx3eno] = "Env([10],[1])";
~genvstr[~idx4eno] = "Env([8],[10])";
~genvstr[~idx5eno] = "Env([0],[1])";
~genvstr[~idx6eno] = "Env([0],[1])";
~genvstr[~levelAeno] = "Env.adsr(0,0,1,0,10,0)";
~genvstr[~levelBeno] = "Env.adsr(0,0,1,0,10,0)";
~genvstr[~filteno] = "Env([10],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});

~instrumentNames = ~instrumentNames.add("Experiment 2");
~instruments = ~instruments.add({
~gconfig = 1;
~goffsets = [0,0,0,0,0,0,0,0,0,0];
~gcf = 0.5;
~gwsAselect = 4; ~gwsBselect = 5;
~gnumerators = [1,1,1,1]; ~gdenominators = [1,5,1,1];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env([0,8.33,8.06,7],[1/6,1/6,2],[0,0,0])";
~genvstr[~idx2eno] = "Env([0],[1])";
~genvstr[~idx3eno] = "Env([10],[1])";
~genvstr[~idx4eno] = "Env([10],[1])";
~genvstr[~idx5eno]= "Env([8],[10])";
~genvstr[~idx6eno] = "Env([10],[1])";
~genvstr[~levelAeno] = "Env.adsr(0,0,1,0,10,0)";
~genvstr[~levelBeno] = "Env.adsr(0,0,1,0,10,0)";
~genvstr[~filteno] = "Env([10],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});

~instrumentNames = ~instrumentNames.add("Experiment 3");
~instruments = ~instruments.add({
~gconfig = 1;
~goffsets = [0,0,0,0,0,0,0,0,0,0];
~gcf = 0.5;
~gwsAselect = 4; ~gwsBselect = 5;
~gnumerators = [1,1,1,1]; ~gdenominators = [1,2,1,2];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env([0,8.33,8.06,7],[1/6,1/6,2],[0,0,0])";
~genvstr[~idx2eno] = "Env([0],[1])";
~genvstr[~idx3eno] = "Env([10],[1])";
~genvstr[~idx4eno] = "Env([10],[1])";
~genvstr[~idx5eno]= "Env([8],[10])";
~genvstr[~idx6eno] = "Env([10],[1])";
~genvstr[~levelAeno] = "Env.adsr(0,0,1,0,10,0)";
~genvstr[~levelBeno] = "Env.adsr(0,0,1,0,10,0)";
~genvstr[~filteno] = "Env([10],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});

~instrumentNames = ~instrumentNames.add("Strange Sweeps");
~instruments = ~instruments.add({
~gconfig = 0;
~goffsets = [0,0,0,0,0,0,0,0,0,0];
~gcf = 0.5;
~gwsAselect = 5; ~gwsBselect = 6;
~gnumerators = [1,1,1,1]; ~gdenominators = [1,2,1,4];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env([5,8,5,8,5,8,5,8],1.5*[1,1,1,1,1,1,10])";
~genvstr[~idx2eno] = "Env([10,0,10],[4,4])";
~genvstr[~idx3eno] = "Env([5,10,5,10,5,10,5,10],[1.5,1.5,1,1,1.5,1.5,10])";
~genvstr[~idx4eno] = "Env([5,8,5,8,5,8,5,8],1.8*[1,1,1,1,1,1,10])";
~genvstr[~idx5eno] = "Env([10,0,10],[4,4])";
~genvstr[~idx6eno] = "Env([5,10,5,10,5,10,5,10],[1,1.5,1.5,1,1.5,1.5,1])";
~genvstr[~levelAeno] = "Env.adsr(0.1,0,1,0,10,0)";
~genvstr[~levelBeno] = "Env.adsr(0.1,0,1,0,10,0)";
~genvstr[~filteno] = "Env([10],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});

~instrumentNames = ~instrumentNames.add("Tubular Bells");
~instruments = ~instruments.add({
~gconfig = 1;
~goffsets = [0,0,0,0,0,0,0,0,0,0];
~gcf = 0.5;
~gwsAselect = 0; ~gwsBselect = 0;
~gnumerators = [1.003,7.035,0.995,6.98]; ~gdenominators = [1,2,1,2];
~genvstr = Array.fill(~numberEnvs);
~genvstr[~idx1eno] = "Env.adsr(0,5,0,5,7.5,0)";
~genvstr[~idx2eno] = "Env([0],[1])";
~genvstr[~idx3eno]= "Env([10],[1])";
~genvstr[~idx4eno] = "Env.adsr(0,5,0,5,7.8,0)";
~genvstr[~idx5eno]  = "Env([0],[1])";
~genvstr[~idx6eno] = "Env([10],[1])";
~genvstr[~levelAeno] = "Env.adsr(0,5,0,5,10,0)";
~genvstr[~levelBeno] = "Env.adsr(0,5,0,5,10,0)";
~genvstr[~filteno] = "Env([10],[1])";
~genvstr[~reseno] = "Env([0],[1])";
});