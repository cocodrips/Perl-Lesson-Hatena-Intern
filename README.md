```
 ___       _                        ____  _                  
|_ _|_ __ | |_ ___ _ __ _ __       |  _ \(_) __ _ _ __ _   _ 
 | || '_ \| __/ _ \ '__| '_ \ _____| | | | |/ _` | '__| | | |
 | || | | | ||  __/ |  | | | |_____| |_| | | (_| | |  | |_| |
|___|_| |_|\__\___|_|  |_| |_|     |____/|_|\__,_|_|   \__, |
                                                       |___/ 
```

## セットアップ
以下のコマンドを実行。
```
$ script/setup.sh
```


##user
	id bigint
	name unique string(32)
	cretated TIMESTAMP
	diary bigint 
	

##diary
	id bigint
	user_id
	title 

##entry
	id
	entree_id
	comment
	date
	


