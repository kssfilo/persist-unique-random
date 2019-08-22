SeedRandom=require 'seedrandom'
Fs=require 'fs'
Path=require 'path'

PersistUniqueRandom=class
	_ModuleName='persist-unique-random'

	_D:(str)->
		console.error "#{_ModuleName}:#{str}" if @isDebugMode

	_ID:->
		"#{@id}#{@min}-#{@max}"
	
	_P:->
		@p[@_ID()] ? null

	_generateArray:->
		{min,max}=@
		random=SeedRandom @_P().seed
		da=[]
		sa=[min..max-1]
		while sa.length
			da.push sa.splice(Math.floor(random()*sa.length),1)

		@array=da

	constructor:(opt)->
		@p={}
		@fileDir=opt.fileDir ? Path.join process.env["HOME"],".#{_ModuleName}"
		@fileName=opt?.fileName ? 'persist-unique-random.json'
		@filePath=Path.join @fileDir,@fileName
		@isDebugMode=opt?.isDebugMode
		@max=opt?.max ? 16
		@min=opt?.min ? 0
		@id=opt?.id ? "ID"
		@persist=opt?.persist ? true
		@reshuffle=opt?.reshuffle

		unless @load() and @_P()
			@reset()

		if opt?.forceSeed?
			@_P().seed=opt.forceSeed

		@_generateArray()

	reset:()->
		@_D "resetting random array id:#{@_ID()}"
		@p[@_ID()]={}
		@_P().seed=Math.floor Math.random()*0x10000000
		@_P().index=0
		@save()
	
	resetAll:->
		@_D "clearing all random arrays"
		@p={}
		@reset()
		@save()

	save:()->
		return unless @persist
		@_D "saving to #{@filePath}..."
		if !Fs.existsSync @fileDir
			@_D "#{@fileDir} doesn't exist. try mkdir"
			Fs.mkdirSync @fileDir

		@_D "data:#{JSON.stringify @p}"
		Fs.writeFileSync @filePath,JSON.stringify @p

	load:()->
		return false unless @persist
		try
			@_D "loading from #{@filePath}.."
			@p=JSON.parse Fs.readFileSync @filePath
			@_D "data:#{JSON.stringify @p}"
			return true
		catch e
			@_D "file doesnt exists.skip."
			return false

	next:()->
		@_D @array
		@_D @_P().index

		r=@array[@_P().index++]
		if @_P().index >= @array.length
			if @reshuffle
				@_D "option.reshuffle is specified. re-generate array.."
				@reset()
				@_generateArray()
			@_P().index=0
		@save()
		r

module.exports=PersistUniqueRandom