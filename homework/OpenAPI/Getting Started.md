## Editor
https://editor.swagger.io/
![54%](https://progress-bar.dev/54)
^ progress ... of the [specification](https://learn.openapis.org/specification/)
## Something about OpenAPI
- auto code gen for various languages
- easily understandable standard format, which is easier to understand for humans and computers too (**contracts**, and **specification**)
- auto document generation
- avoid time sinks
- generate boilerplate 
- auto gen mock servers for testing
- https://tools.openapis.org/ tool list
- if could not redesign API, it can be left out from *OpenAPI Description*
- [RESTful, websocket, CoAP]
- it's something like interfaces in programing languages


## Soft landing
Building blocks of OAD: 
- `openapi.yaml` (yaml 1.2) (yaml is superset of json - allows mixing of syntaxes)
- visualization tool: https://openapi-map.apihandyman.io/
 - necessary fiels are marked in red [any one of paths / components / webhook] is required
 ![[Pasted image 20231107181221.png]]
	 - openapi - version (3.10)
	 - **info** - about the author [title, version]
	 - **paths** - describe all endpoints in a server
		 - query / path **parameters**
		 - **schema** (basic) / **content** (adv)  - must present
			 - customize serialization
		 - **requestbody** 
			 - **content** is must
				 - **headers** with all possible values [enum] etc
				 - **schema**
					 - variable name
					 - [datatype, range, enum, array]
		 - **response**
			 - description
			 - xxx http code
				 - response **schema**

## Checkpoint  
- [upnext](https://learn.openapis.org/specification/components) reusing description
