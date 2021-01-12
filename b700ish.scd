(
// This is b700ish
// A vague attempt to implement a rough guess of the
// Buchla 700 voice architecture in Supercollider
// Aaron Lanterman, October 21, 2020

// Make sure you also have b700ish_patches.scd file and store it in the same directory as b700ish.scd.

// Execute this whole-file code block to start.
// There's a bug where you need to manually select a patch from the patch menu before sound will start.
// The Patch drop-down menu is in the upper right corner; I think any patch will do.
// You can use a MIDI controller or the key buttons in the lower right corner of the GUI.
s.boot;
s.scope;
FreqScope.new;

~trianglePink = Color(255/255,0,170/255,1);
~circleBlue = Color(0,170/255,255/255,1);
~squareOrange = Color(255/255,170/255,0,1);
~squareGreen = Color(0,255/255,170/255,1);

~envTitleStrings = ["Idx1","Idx2","Idx3","Idx4","Idx5","Idx6", "LvlA", "LvlB", "Filt", "Res"];
~envTitleColors = (~trianglePink ! 6) ++ [~squareOrange] ++ [~squareGreen] ++ (Color.black ! 2);
~numberEnvs = ~envTitleStrings.size;

~idx1eno = 0; ~idx2eno = 1; ~idx3eno = 2;
~idx4eno = 3; ~idx5eno = 4; ~idx6eno = 5;
~levelAeno = 6; ~levelBeno = 7;
~filteno = 8; ~reseno = 9;

(thisProcess.nowExecutingPath.dirname ++ "/b700ish_patches.scd").load;
if (~currentPatch.isNil,{~currentPatch=0});
~instruments[~currentPatch].value;

~chebyNames = Array.new;
~chebyCoefs = Array.new;
~chebyNames = ~chebyNames.add("Default");
~chebyCoefs = ~chebyCoefs.add([1]);
~chebyNames = ~chebyNames.add("True Triangle ");
~chebyCoefs = ~chebyCoefs.add([1,0] / ((1..32).squared));
~chebyNames = ~chebyNames.add("Square-Compatible Triangle");
~chebyCoefs = ~chebyCoefs.add([1,0,-1,0] / ((1..32).squared));
~chebyNames = ~chebyNames.add("Jimmy Smith (All Positive)");
~chebyCoefs = ~chebyCoefs.add([1,1,1]);
~chebyNames = ~chebyNames.add("Jimmy Smith");
~chebyCoefs = ~chebyCoefs.add([1,1,-1]);
~chebyNames = ~chebyNames.add("Full Tonewheel");
~chebyCoefs = ~chebyCoefs.add([1,1,-1,-1,0,1,0,-1,0,1,0,-1,0,0,0,1]);
~chebyNames = ~chebyNames.add("True Square");
~chebyCoefs = ~chebyCoefs.add([1,0,-1,0] / (1..32));
~chebyNames = ~chebyNames.add("Triangle-Compatible Square");
~chebyCoefs = ~chebyCoefs.add([1,0] / (1..32));
~chebyNames = ~chebyNames.add("Alt Saw");
~chebyCoefs = ~chebyCoefs.add(0.25*[1,-1,-1,1] / (1..32));
~chebyNames = ~chebyNames.add("Alt Impulse Train");
~chebyCoefs = ~chebyCoefs.add(0.1*[1,-1,-1,1]*Array.fill(32,1));
~chebyNames = ~chebyNames.add("Alt Sign-Flipping Impulse Train");
~chebyCoefs = ~chebyCoefs.add(0.1*[1,0,-1,0]*Array.fill(32,1));

~wsdefaultsig = Signal.chebyFill(4096, [1], normalize: true, zeroOffset:false);
~wsdefault = ~wsdefaultsig.asWavetableNoWrap;
~wsdefaultbuf = Buffer.loadCollection(s, ~wsdefault);

SynthDef.new(\fbfm, {
	arg freq = 220, gate = 0, config = 1, offsets = #[0,0,10,0,0,10,10,10,10,0],
	    numerators = #[1,1,1,1], denominators = #[1,1,1,1],
	    cf = 0,
	    wsAbuf = ~wsdefaultbuf, wsBbuf = ~wsdefaultbuf;

	var cfreq = freq;
    var po = LocalIn.ar(4);
	var freqs = cfreq * numerators / denominators;

	var out, oo, fmodinputs, tm2, tm5, wsAoutput, wsBoutput, wsMix;
	var levelA, levelB, rawlevelA, rawlevelB;

	var acousticVars,rawindexes,max_rawindex,io0,io1,io2,io3,io4,io5,io6;

    var envidx1, envidx2, envidx3, envidx4, envidx5, envidx6;
	var envfilt, envres, envlevelA, envlevelB;
    var filtercontrol, rescontrol;

	var envidx1trick = Env.newClear(8);
	var envidx2trick  = Env.newClear(8);
	var envidx3trick  = Env.newClear(8);
	var envidx4trick  = Env.newClear(8);
	var envidx5trick  = Env.newClear(8);
	var envidx6trick  = Env.newClear(8);
    var envfilttrick  = Env.newClear(8);
	var envrestrick  = Env.newClear(8);
	var envlevelAtrick  = Env.newClear(8);
    var envlevelBtrick  = Env.newClear(8);

	envidx1 = \env1.kr(envidx1trick.asArray);
	envidx2 = \env2.kr(envidx2trick.asArray);
	envidx3 = \env3.kr(envidx3trick.asArray);
	envidx4 = \env4.kr(envidx4trick.asArray);
	envidx5 = \env5.kr(envidx5trick.asArray);
	envidx6 = \env6.kr(envidx6trick.asArray);
	envlevelA = \envlA.kr(envlevelAtrick.asArray);
	envlevelB = \envlB.kr(envlevelBtrick.asArray);
	envfilt = \envf.kr(envfilttrick.asArray);
	envres = \envr.kr(envrestrick.asArray);

    acousticVars = Clip.kr(offsets.lag(0.5) +
	   [EnvGen.kr(envidx1,gate), EnvGen.kr(envidx2,gate), EnvGen.kr(envidx3,gate),
	    EnvGen.kr(envidx4,gate), EnvGen.kr(envidx5,gate), EnvGen.kr(envidx6,gate),
		EnvGen.kr(envlevelA,gate,doneAction: Done.freeSelf),
		EnvGen.kr(envlevelB,gate,doneAction: Done.freeSelf),
		EnvGen.kr(envfilt,gate), EnvGen.kr(envres,gate)],
		0,10);

	filtercontrol = acousticVars[~filteno];
	rescontrol = acousticVars[~reseno];
	levelA = acousticVars[~levelAeno];
	levelB = acousticVars[~levelBeno];

	//rawindexes =
	//   8*pi*(2**(((127*[acousticVars[~idx1eno],acousticVars[~idx2eno],acousticVars[~idx3eno],
	//	                acousticVars[~idx4eno],acousticVars[~idx5eno],acousticVars[~idx6eno]]
     //             /10)-135)/8));

	rawindexes = pi*(2**((33/16)-((100-(10*
		[acousticVars[~idx1eno],acousticVars[~idx2eno],acousticVars[~idx3eno],
	     acousticVars[~idx4eno],acousticVars[~idx5eno],acousticVars[~idx6eno]]))/8)));

     max_rawindex = pi*(2**(33/16));

	// index triangle outputs
	 io0 = rawindexes[0] * Select.ar(config,
		    [po[2-1],po[2-1],po[2-1],po[1-1],po[1-1],po[1-1],
			 po[3-1],po[4-1],po[3-1],po[4-1],po[3-1],po[1-1]]);
	 io1 = rawindexes[1] * Select.ar(config,
		    [po[4-1],po[2-1],po[3-1],po[3-1],po[2-1],po[4-1],
			 po[2-1],po[2-1],po[2-1],po[3-1],po[2-1],po[2-1]]);

	 io3 = rawindexes[3] * Select.ar(config,
		    [po[2-1],po[4-1],po[4-1],po[2-1],po[3-1],po[3-1],
		     po[4-1],po[4-1],po[3-1],po[2-1],po[1-1],po[4-1]]);
	 io4 = rawindexes[4] * Select.ar(config,
		    [po[4-1],po[4-1],po[1-1],po[3-1],po[4-1],po[2-1],
			 po[1-1],po[4-1],po[1-1],po[1-1],po[2-1],po[3-1]]);

  // index triangles 3 and 6 (on images), i.e. 2 and 5 in code, only feed wavetables
   fmodinputs = [Select.ar(config,[io0,io0,io0,io1,io1,io1,
		                           io1,io1,io1,io0,io1,io4]),
	             Select.ar(config,[Silent.ar,Silent.ar,io1,io4,io3,Silent.ar,
		                           io0,io0,io3,io1,Silent.ar,io0]),
	             Select.ar(config,[io3,io3,io3,Silent.ar,Silent.ar,io4,
		                           Silent.ar,Silent.ar,Silent.ar,io3,io4,Silent.ar]),
	             Select.ar(config,[Silent.ar,Silent.ar,io4,Silent.ar,Silent.ar,Silent.ar,
		                           Silent.ar,Silent.ar,Silent.ar,io4,Silent.ar,Silent.ar])];

	fmodinputs[0] = fmodinputs[0] +
	        Select.ar(config,[Silent.ar,Silent.ar,Silent.ar,Silent.ar,Silent.ar,Silent.ar,
	                          io3,io3,Silent.ar,Silent.ar,Silent.ar,Silent.ar]);
	fmodinputs[1] = fmodinputs[1] +
	        Select.ar(config,[Silent.ar,Silent.ar,Silent.ar,Silent.ar,io4,Silent.ar,
	                          Silent.ar,Silent.ar,Silent.ar,Silent.ar,Silent.ar,Silent.ar]);

    // oscillator outputs
	oo = SinOsc.ar(freqs,fmodinputs);

    // index triangles 3 and 6 (on images), i.e. 2 and 5 in code, only feed wavetables
	tm2 = Select.ar(config,[io1,io1,Silent.ar,io0,Silent.ar,io0,
		                    Silent.ar,Silent.ar,io0,Silent.ar,io0,io3]);
	tm5 = Select.ar(config,[io4,io4,Silent.ar,io3,Silent.ar,io3,
		                    Silent.ar,io4,io4,Silent.ar,io3,io1]);

	// Since the output of index triangles 3 and 6 (on images), i.e. 2 and 5 in code,
	// doesn't involve any feedback mechanisms, we might as well use oo intead of po.
	io2 = ((rawindexes[2] + tm2) / max_rawindex) *
	      Select.ar(config,
	     [oo[1-1],oo[1-1],oo[1-1],oo[4-1],oo[1-1],oo[2-1],
		  oo[1-1],oo[1-1],oo[1-1],oo[1-1],oo[1-1],oo[1-1]]);

	io5 = ((rawindexes[5] + tm5) / max_rawindex) *
	      Select.ar(config, [oo[3-1],oo[3-1],oo[3-1],oo[4-1],oo[1-1],oo[4-1],
		 	                 oo[1-1],oo[4-1],oo[4-1],oo[3-1],oo[3-1],oo[1-1]]);

    LocalOut.ar(oo);
	wsAoutput = Shaper.ar(wsAbuf, io2);
	wsBoutput = Shaper.ar(wsBbuf, io5);

	//rawlevelA = 8*pi*(2**(((127*levelA/10)-135)/8));
    //rawlevelB = 8*pi*(2**(((127*levelB/10)-135)/8));

	rawlevelA = pi*(2**((33/16)-((100-(10*levelA))/8)));
	rawlevelB = pi*(2**((33/16)-((100-(10*levelB))/8)));

	wsAoutput = (rawlevelA / max_rawindex) * wsAoutput;
    wsBoutput = (rawlevelB / max_rawindex) * wsBoutput;
	wsMix = (wsBoutput * cf) + (wsAoutput * (1 - cf));
	out = wsMix;
	out = MoogFF.ar(wsMix, 20*(2**filtercontrol), 4 * rescontrol/10);
	Out.ar(0, 0.2*[out, out]);
}).add;

///////////////

MIDIClient.init;
MIDIIn.connectAll;

~notes = Array.newClear(128);    // array has one slot per possible MIDI note

~startNote = { arg velocity, noteNumber;
	~vel = velocity / 127;
	~nn = noteNumber;
	~genvstr.do({arg item, i;
	             var realenv = try {item.compile.value;} {arg error; };
	             if(realenv.isKindOf(Env),
	                {~genv[i] = realenv;
				{~envtitles[i].stringColor = ~darkGreen;}.defer;
			},
	             {~genv[i] = nil;
				postln("Charm");
				{~envtitles[i].stringColor = Color.red;}.defer;}
	             );
	           });
	~notes[noteNumber] = Synth.new(\fbfm, [\freq, (noteNumber).midicps, \gate, 1,
		                             \config, ~gconfig,
		                             \offsets, ~goffsets,
		                             \numerators, ~gnumerators,
		                             \denominators, ~gdenominators,
		                             \cf, ~gcf,
				\wsAbuf, ~gwsAbuf, \wsBbuf, ~gwsBbuf,
		// it seems like SC doesn't want me to pass in ~genvinv all at once,
		// as an array; when compiling the synthdef, it complains that
		// the "message 'at' is not understood" -- not sure why...
		\env1, ~genv[~idx1eno], \env2, ~genv[~idx2eno], \env3, ~genv[~idx3eno],
		\env4, ~genv[~idx4eno], \env5, ~genv[~idx5eno], \env6, ~genv[~idx6eno],
		\envlA, ~genv[~levelAeno], \envlB, ~genv[~levelBeno],
	    \envf, ~genv[~filteno], \envr, ~genv[~reseno]
	]);
	 ~notes[noteNumber].register;
};

~stopNote = { arg velocity, noteNumber;
	~notes[noteNumber].set(\gate, 0);
	~notes[noteNumber] = nil;
};


MIDIdef.noteOn(\noteOnTest,{ arg velocity, noteNumber, chan, src;
	~startNote.value(velocity, noteNumber)});

MIDIdef.noteOff(\noteOffTest, { arg velocity, noteNumber, chan, src;
	~stopNote.value(velocity, noteNumber); });

~updateGUI = {
~cfimages = Array.fill(12,
	{arg i;
	 Image.new("/Users/lanterma/buchla700_supercollider/fm_config_c_"
		++ i.asStringToBase(width: 2) ++ ".png"); });

 if(w.notNil,
   {if(w.isClosed,
	   {~currentBounds = Rect(0,540,700,600)},
	   {~currentBounds = w.bounds;
		~currentBounds.top = ~currentBounds.top+22;
	   });},
	{~currentBounds = Rect(0,540,700,600)});

Window.closeAll;
~forceOnTop = false;
w = Window("B700ish",~currentBounds,resizable: false).front.alwaysOnTop_(~forceOnTop);

~cfknob = Knob(w,Rect(330,110,32,32))
         .action_({arg obj;
	              ~notes.do({arg item;
		                     ~gcf = obj.value;
	                         if (item.isPlaying,
				                 {item.set(\cf,~gcf);});
	                        });
                  })
         .value = ~gcf;

StaticText(w, Rect(165,150,160,40)).string_("Frequency Ratios:");

~numtextboxes = Array.fill(4,
	{arg i;
	  var tf = TextField(w,Rect(165+(40*i),182,37,22))
		.action_({arg obj;
			      var vaf = obj.value.asFloat;
			      if(vaf != 0,
				     {~gnumerators[i] = vaf;
					  ~notes.do({arg item;
					             if(item.isPlaying,
						           {item.seti(\numerators,i,vaf);});
					             })
			         });
			      obj.value = ~gnumerators[i].asString;
		         });
		tf.string = ~gnumerators[i].asString;
		tf;
    });

~denomtextboxes = Array.fill(4,
	{arg i;
	  var tf = TextField(w,Rect(165+(40*i),207,37,22))
		.action_({arg obj;
			      var vaf = obj.value.asFloat;
			      if(vaf != 0,
				     {~gdenominators[i] = vaf;
                      ~notes.do({arg item;
					             if(item.isPlaying,
						           {item.seti(\denominators,i,vaf);});
					             })
			         });
			      obj.value = ~gdenominators[i].asString;
		         });
	    tf.string = ~gdenominators[i].asString;
		tf;
    });

w.drawFunc_({~cfimages[~gconfig].tileInRect(Rect(10,182,128,128))});
w.refresh;

StaticText(w, Rect(10,150,160,40)).string_("Config:");

~configselect = PopUpMenu(w, Rect(60, 160, 40, 20));
~configselect.items = Array.series(12);
~configselect.value = ~gconfig;
~configselect.action =
   { arg obj;
	 ~gconfig = obj.value;
	 w.drawFunc_({~cfimages[~gconfig].tileInRect(Rect(10,182,128,128))});
	 w.refresh; // need this so new image appears
	 ~notes.do({arg item;
		        if(item.isPlaying,
				   {item.set(\config,~gconfig);})
	           });
   };

~setupAbuf = { arg selection;
               ~wsAsig = Signal.chebyFill(4096, ~chebyCoefs[selection],
		                                  normalize: true, zeroOffset:false);
               ~wsA = ~wsAsig.asWavetableNoWrap;
               ~gwsAbuf = Buffer.loadCollection(s, ~wsA);
             };

~setupBbuf = { arg selection;
               ~wsBsig = Signal.chebyFill(4096, ~chebyCoefs[selection],
		                                  normalize: true, zeroOffset:false);
               ~wsB = ~wsBsig.asWavetableNoWrap;
               ~gwsBbuf = Buffer.loadCollection(s, ~wsB);
};

~envtitles = Array.fill(~numberEnvs,
	{arg i;
			StaticText(w, Rect(5,310+(25*i),40,40)).string_(~envTitleStrings[i] ++ ":").align_(\left)
    });

~darkGreen = Color(0,0.5,0,1);
~genv = Array.fill(~numberEnvs);
~envtextboxes = Array.fill(~numberEnvs,
	{arg i;
	 var realenv = nil;
	 var tf = TextField(w,Rect(40,320+(25*i),300,22))
		.action_({arg obj;
			      var realenv = nil;
				  ~vel = 1; ~nn = 60;
			      realenv = try {obj.value.compile.value;} {arg error; };
			      ~genvstr[i] = obj.value;
			      if(realenv.isKindOf(Env),
				     {~genv[i] = realenv;
					  ~envtitles[i].stringColor = ~darkGreen;},
				     {~genv[i] = nil;
				      ~envtitles[i].stringColor = Color.red;}
			        );
		         });
			~genvstr;
	tf.value = ~genvstr[i];
	~vel = 1; ~nn = 60;
    realenv = try {~genvstr[i].compile.value;} {arg error; };
	if(realenv.isKindOf(Env),
	   {~genv[i] = realenv;
		~envtitles[i].stringColor = ~darkGreen;
				},
	   {~genv[i] = nil;
		~envtitles[i].stringColor = Color.red;}
	  );
	 tf;
    });
~goffsets[1]; //8.4

~offsetSliders = Array.fill(~numberEnvs,
	{arg i;
	 Slider(w,Rect(10+(32*i),6,20,128))
		.action_({arg obj;
			~goffsets[i] = 10*(obj.value);
			~notes.do({arg item;
			           if (item.isPlaying,
					       {item.seti(\offsets,i,~goffsets[i]);}
				          );
			        });
		}).knobColor_(~envTitleColors[i]).value = (~goffsets[i] / 10);
	StaticText(w, Rect(0+(32*i),120,40,40)).string_(~envTitleStrings[i]).align_(\center);
});

~setupAbuf.value(~gwsAselect);
~setupBbuf.value(~gwsBselect);

~makeAplots = {
	~plotterA = Plotter("",Rect(350,182,190,100),w);
    ~plotterA.plotColor_(Color.red);
    ~plotterA.value = ~wsAsig;
	~plotterAsinin = Plotter("",Rect(550,182,100,100),w);
    ~plotterAsinin.plotColor_(Color.red);
	// There has to be a more elegant way to do this...
	~plotterAsinin.value =
        Array.fill(100,{arg n; ~wsAsig[(~wsAsig.size - 1) * (sin(2*pi*n / 100)+1)/2]});
};

~makeBplots = {
	~plotterB = Plotter("",Rect(350,310,190,100),w);
    ~plotterB.plotColor_(Color.green);
    ~plotterB.value = ~wsBsig;
	~plotterBsinin = Plotter("",Rect(550,310,100,100),w);
	~plotterBsinin.plotColor_(Color.green);
	// There has to be a more elegant way to do this...
	~plotterBsinin.value =
	    Array.fill(100,{arg n; ~wsBsig[(~wsBsig.size - 1) * (sin(2*pi*n / 100)+1)/2]});
};

~makeAplots.value();
~makeBplots.value();

StaticText(w, Rect(350,150,160,40)).string_("WaSh A:");
~wsAselect = PopUpMenu(w, Rect(408, 160, 130,20));
~wsAselect.items = ~chebyNames;
~wsAselect.value = ~gwsAselect;
~wsAselect.action = { arg obj;
	        ~gwsAselect = obj.value;
            ~setupAbuf.value(~gwsAselect);
~makeAplots.value();
            };

StaticText(w, Rect(350,278,160,40)).string_("WaSh B:");
~wsBselect = PopUpMenu(w, Rect(408, 288, 130, 20));
~wsBselect.items = ~chebyNames;
~wsBselect.value = ~gwsBselect;
~wsBselect.action = { arg obj;
	        ~gwsBselect = obj.value;
~setupBbuf.value(~gwsBselect);
	~makeBplots.value();
            };

StaticText(w, Rect(350,50,160,40)).string_("Patch:");
~patchselect = PopUpMenu(w, Rect(395, 60, 250,20));
~patchselect.items = ~instrumentNames;
~patchselect.value = ~currentPatch;
~patchselect.action = { arg obj;
	        ~currentPatch = obj.value;
	        ~instruments[~currentPatch].value;
		    ~updateGUI.value;
 };

~keysrow1 = Array.fill(13, {arg i;
		Button(w, Rect(350+(22*i), 430, 20, 40))
	         .states_([["", Color.white, Color.white]])
            .mouseDownAction_({~startNote.value(127, 36+i)})
		    .mouseLeaveAction_({~stopNote.value(127, 36+i)})
		    .action_({~stopNote.value(127, 36+i)});
	    });

~keysrow2 = Array.fill(13, {arg i;
		Button(w, Rect(350+(22*i), 472, 20, 40))
	         .states_([["", Color.white, Color.white]])
            .mouseDownAction_({~startNote.value(127, 12+36+i)})
		    .mouseLeaveAction_({~stopNote.value(127, 12+36+i)})
		    .action_({~stopNote.value(127, 12+36+i)});
	    });

~keysrow2 = Array.fill(13, {arg i;
		Button(w, Rect(350+(22*i), 514, 20, 40))
	         .states_([["", Color.white, Color.white]])
            .mouseDownAction_({~startNote.value(127, 24+36+i)})
		    .mouseLeaveAction_({~stopNote.value(127, 24+36+i)})
		    .action_({~stopNote.value(127, 24+36+i)});
	    });
};

~updateGUI.value;
)
