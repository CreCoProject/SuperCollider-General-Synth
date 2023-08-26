(
SynthDef(\help_MasterSynth, { |out = 0, freq = 440, adsra = 1, adsrd = 1, adsrs = 1, adsrr = 1, startBelow = 1, endBelow = 10, startAbove = 2, endAbove = 30, form1 = 880, form2 = 1760, form3 = 3520, forma1 = 0, forma2 = 0, forma3 = 0, verbmix = 0.5, verbroom = 0.5, verbdamp = 0.5|
	var sig, // Variable for master Signal
	// Signals in the Equalizer
	sigeq1, sigeq2, sigeq3, sigeq4, sigeq5, sigeq6,
	// Signals in the Formant
	formsig1, formsig2, formsig3,
	// Envelopes for the Equalizer
	env1, env2, env3, env4, env5, env6,
	eqtrans1, eqtrans2,
	amp,
	envm; // Master Envelope

	// Impulse Generator for Impulse
	sig = Impulse.ar(freq);

	// Equalizer BandPasses
	sigeq1 = BPF.ar(sig, freq, 0.01);
	sigeq2 = BPF.ar(sig, freq*2, 0.01);
	sigeq3 = BPF.ar(sig, freq*3, 0.01);
	sigeq4 = BPF.ar(sig, freq*4, 0.01);
	sigeq5 = BPF.ar(sig, freq*5, 0.01);
	sigeq6 = BPF.ar(sig, freq*6, 0.01);

	// Envelopes for the Equalizer Signals
	// with cacuated Window Shapes
	eqtrans1 = startBelow;
	eqtrans2 = startAbove;
	env1 = Env.perc(eqtrans1, eqtrans2);
    sigeq1 = sigeq1 * EnvGen.kr(env1);

	eqtrans1 = endBelow;
	eqtrans2 = endAbove;
	env2 = Env.perc(eqtrans1, eqtrans2);
    sigeq2 = sigeq2 * EnvGen.kr(env2);

	eqtrans1 = startBelow + (((endBelow-startBelow)/5)*2);
    eqtrans2 = startAbove + (((endAbove-startAbove)/5)*2);
	env3 = Env.perc(eqtrans1, eqtrans2);
    sigeq3 = sigeq3 * EnvGen.kr(env3);


	eqtrans1 = startBelow + (((endBelow-startBelow)/5)*3);
	eqtrans2 = startAbove + (((endAbove-startAbove)/5)*3);
	env4 = Env.perc(eqtrans1, eqtrans2);
    sigeq4 = sigeq4 * EnvGen.kr(env4);

	eqtrans1 = startBelow + (((endBelow-startBelow)/5)*4);
	eqtrans2 = startAbove + (((endAbove-startAbove)/5)*4);
	env5 = Env.perc(eqtrans1, eqtrans2);
    sigeq5 = sigeq5 * EnvGen.kr(env5);


	eqtrans1 = endBelow;
	eqtrans2 = endAbove;
	env6 = Env.perc();
    sigeq6 = sigeq6 * EnvGen.kr(env6);

	// Formant Section
	formsig1 = (BPF.ar(sig, form1, 0.01) * forma1)/1;
	formsig2 = (BPF.ar(sig, form2, 0.01) * forma2)/1;
	formsig3 = (BPF.ar(sig, form3, 0.01) * forma3)/1;


	// Recreate the MasterSignal

	sig = sigeq1 + sigeq2 + sigeq3 + sigeq4 + sigeq5 + sigeq6;
	sig = sig + formsig1 + formsig2 + formsig3;

	envm = Env.linen(adsra, adsrs, adsrr);
	sig = sig * EnvGen.kr(envm, doneAction: Done.freeSelf);

	sig = sig * 16;

	sig = FreeVerb.ar(sig, verbmix, verbroom, verbdamp);
	sig = FreeVerb.ar(sig, verbmix, verbroom, verbdamp);
	sig = FreeVerb.ar(sig, verbmix, verbroom, verbdamp);


	// Output of the Master Signal
	Out.ar(out, [sig, sig])
}).add;
)

(

x = Synth(\help_MasterSynth, [\freq, 440 , \startBelow, (10.30.rand2)/10, \startAbove, (10.30.rand2)/10, \endBelow, (10.30.rand2)/10, \endAbove, (10.30.rand2)/10, \adsra, (1.3.rand2), \adsrs, 1, \adsrr, (1.3.rand2), \form1, 220.2200.rand2, \form2, 220.2200.rand2, \form3, 220.2200.rand2, \forma1, (0.100.rand2/100), \forma2, (0.100.rand2/100), \forma3, (0.100.rand2/100),
]);
)

Env.adsr((1.3.rand2), (1.3.rand2), 0.5, (1.3.rand2)).test(2).plot;