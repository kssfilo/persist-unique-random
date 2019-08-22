#!/usr/bin/env coffee
GetOpt=require '@kssfilo/getopt'

AppName="@PARTPIPE@BINNAME@PARTPIPE@"
PackageName="@PARTPIPE@NAME@PARTPIPE@"

P=console.log
E=(e)=>
	switch
		when typeof(e) in ['string','value']
			console.error e
		when ctx.isDebugMode
			console.error e.toString()
		else
			###
			if e[0]?.message
				console.error e[0].message
			else
			###
			console.error e

D=(str)=>
	E "#{AppName}:"+str if ctx.isDebugMode

ctx={
	command:'print'
	isDebugMode:false
}

optUsages=
	h:"show this help"
	d:"debug mode"
	r:"reset specified random array. "
	R:"reset all random arrays."
	i:["id","random array id. random arrays are saved per id+min+max pair. default('ID')"]
	x:["max","max value. e.g. 10 -> [0..9]. default:16"]
	n:["min","min value. default:0"]
	s:"re-shuffle when random array loops. default:loops same array"
	S:["number","force override seed number. e.g. 12345. default:random number or saved seed."]
	D:["dir","directory to save random array seeds. default:$HOME/.@PARTPIPE@NAME@PARTPIPE@"]
	f:["file","file name to save random array seeds. default:@PARTPIPE@NAME@PARTPIPE@"]
	N:"don't save/load random arrays.(generates non-unique random number)"

try
	GetOpt.setopt 'h?drRi:x:n:sS:D:f:N'
catch e
	switch e.type
		when 'unknown'
			E "Unknown option:#{e.opt}"
		when 'required'
			E "Required parameter for option:#{e.opt}"
	process.exit(1)

try
	GetOpt.getopt (o,p)->
		switch o
			when 'h','?'
				ctx.command='usage'
			when 'd'
				ctx.isDebugMode=true
			when 'r'
				ctx.command='reset'
			when 'R'
				ctx.command='resetAll'
			when 'i'
				ctx.id=p[0]
			when 'n'
				ctx.min=Number p[0]
			when 'x'
				ctx.max=Number p[0]
			when 'D'
				ctx.fileDir=p[0]
			when 'f'
				ctx.fileName=p[0]
			when 'S'
				ctx.forceSeed=Number p[0]
			when 'N'
				ctx.persist=false
			when 's'
				ctx.reshuffle=true

	if ctx.command is 'usage'
		P """
		## Command line
		
			#{AppName} [options]
			
			@PARTPIPE@DESCRIPTION@PARTPIPE@
			
			Copyright (C) 2019-@PARTPIPE@|date +%Y;@PARTPIPE@ @kssfilo(https://kanasys.com/gtech/)

		## Options

		#{GetOpt.getHelp optUsages}		

		## Examples
		
		"""

		process.exit 0

	D "==starting #{AppName}"
	D "sanity checking.."
	D "..OK"
	D "-------"
	D "-options"
	D "#{JSON.stringify ctx,null,2}"

	if ctx.isDebugMode
		E "command:#{ctx.restCommand}" if ctx.restCommand?
		E "method:#{ctx.command}" if ctx.restCommand?
		E "params:#{JSON.stringify ctx.restParam}" if ctx.restParam?

	PersistUniqueRandom=require './persist-unique-random'
	command=ctx.command
	delete ctx.command
	rng=new PersistUniqueRandom ctx #sinse of compatibility

	switch command
		when 'print'
			P "#{rng.next()}"
		when 'reset'
			rng.reset()
			E 'OK'
		when 'resetAll'
			rng.resetAll()
			E 'OK'

catch e
	E console.error e.toString()
	process.exit 1



