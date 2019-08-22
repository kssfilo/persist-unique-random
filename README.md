# persist-unique-random - Unique Random Array Generator with Persist(saving to file) Feature + Command Line Tool

An Unique Random Array Generator with Persist(saving to file) Feature + Command Line Tool

```
PersistUniqueRandom=require('persist-unique-random');
rng=new PersistUniqueRandom({max:10});

for(var i=0;i<20;i++) console.log(`rng.next() `);
//-> 7 5 6 2 3 8 9 1 4 0 7 5 6 ... (loop)

rngShuffle=new PersistUniqueRandom({max:10,reshuffle:true});

for(var i=0;i<20;i++) console.log(`rng.next() `);
//-> 7 5 6 2 3 8 9 1 4 0 8 2 1 ... (re-shuffle at loop point)

// * arrays are saved to $HOME/.persist-unique-random/persist-unique-random.json per 'id+min+max' pairs.
```

- [Documentation(npmjs)](https://www.npmjs.com/persist-unique-random)
- [Bug Report(GitHub)](https://github.com/kssfilo/persist-unique-random)
- [Home Page](https://kanasys.com/gtech/)


## Module Reference

### constructor(options)

- min: default=0
- max: default=16, range is 0-max-1 . i.e. default is 0-15 integer
- persist: set false if you dont wan't to save array file. default=true
- id: array id. this module keeps each seeds(random arrays) per 'id+min+max' pair. default='ID'
- fileDir: string of directory path of array file. default='$HOME/.persist-unique-random/'
- fileName: string of array file. default='persist-unique-random.json'
- reshuffle: set true is you want to re-shuffle random array at loop point. default=false
- forceSeed: number. force set random seed. 

each seeds and index of unique random arrays are saved to a file to use next run of the process.

seed and index are saved per 'id+min+max' pair.

you can set persist:false to make this module as ordnary unique random array generator. index and arrays are not saved to file. this means random number will not be unique if you re-execute the process.

### next()

returns random integer. index will be saved at this point.

### reset()

reset current (id+min+max) random array.and save file.

### resetAll()

reset all random array.and save file.

## Install(CLI command line tool)

    npm i -g persist-unique-random

@PARTPIPE@|dist/cli.js -h

You can see detail usage on npmjs.com

- [Documentation(npmjs)](https://www.npmjs.com/package/persist-unique-random)

@PARTPIPE@

## Change Log

- 0.1.x: beta release

## Idea


