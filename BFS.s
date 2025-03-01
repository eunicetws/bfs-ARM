	AREA Nodes, DATA
LV  	SPACE 60    	; left value 		// less than current value
RV  	SPACE 60    	; right value 		// more than current value
BFS		SPACE 60		; Binary Tree Binary_Tree
Sorted	SPACE 60		; Binary Tre Sorted
;---------------------------------------------------------------
		
	AREA Breath_First_Search, CODE, READONLY
    ENTRY
	
	LDR r0, =Source					; Source[]
Source DCD 10, 5, 30, 78, 2, 19, 11, 23, 48, 79, 1, 14, 9, 41, 31
	
	LDR r1, =LV						; Left Value
	LDR r2, =RV						; Right Value
Binary_Tree_Start
	
	
Tree_Repeat							; Repeat2{
	MOV r4, #0						; i = 0
	ADD r8, r8, #4					; 	Next Value = i++
	LDR r5, [r0, r4]				; 	Source[i]					//Current Value
	LDR r6, [r0, r8]				; 	Source[i+1]				//Next Value
	
CMP_More_Less						;	Repeat3
	CMP r6, r5						
	BLT Less_Than					; 		IF  Source[i+1] LESS THAN Source[i]	
	BGE Greater_Than				;		IF  Source[i+1] GREATER THAN Source[i]	
	
Load_Less_Then_Index				;	Load Index //not used untill after less than
	LDR r4, [r1, r4]				;		i = Left_Value[i]
	LDR r5, [r0, r4]				; 		Source[i]
	B CMP_More_Less					;		Repeat

Load_More_Then_Index				;	Load Index //not used untill after less than
	LDR r4, [r2, r4]				;		i = Left_Value[i]
	LDR r5, [r0, r4]				; 		Source[i]
	B CMP_More_Less					;		Repeat
	
Less_Than							; 	IF  Source[i+1] LESS THAN Source[i]	
	LDR r10, [r1, r4]				;		IF Left_Value[i] NOT EQUAL 0
	CMP r10, #0	
	BNE Load_Less_Then_Index		;			Repeat3
									;		ELSE
	STR r8, [r1, r4]				;			LV[i] = i+1 (Next Value)
	B Counter						;			Break } 
	
Greater_Than						; 	IF  Source[i+1] LESS THAN Source[i]	
	LDR r10, [r2, r4]				;		IF Left_Value[i] NOT EQUAL 0
	CMP r10, #0	
	BNE Load_More_Then_Index		;			Repeat3
									;		ELSE
	STR r8, [r2, r4]				;			RV[i] = i+1 (Next Value)
	B Counter						;			Break } 

Counter								; Break
	ADD r4, r4, #4					; 	i++
	ADD r9, r9, #1					; 	Counter++
	CMP r9, #14						; 	IF Counter NOT EQUAL 15
	BNE Tree_Repeat					; 		Repeat2	



;----------------------------------------------------------------------------
	LDR r3, =BFS

	MOV r4, #0						; Source_i = 0
	MOV r5, #0						; BFS_i = 0
	MOV r7, #0
	MOV r8, #0
	
	STR r4,[r3, r5]					; Store index 0 into Binary_Tree
	ADD r5, r5, #4					; BFS_i ++
	
BFS_Out						; Repeat
	ADD r7, r7, #1					; 	Counter++
	CMP r7, #15						; 	IF Counter NOT EQUAL 14	; check if it is 15 later uwu
	BEQ Smallest_Start				; 		Leave
	
	LDR r6, [r1, r8]				; 	Left[Source_i]
	CMP r6, #0						; 	IF Left[Source_i] = 0
	BEQ Skip_Left					;		Skip
	
	STR r6, [r3, r5]				; 	Else : Store to BFS[BFS_i]
	ADD r5, r5, #4					; 	BFS_i ++
	
Skip_Left			
	LDR r6, [r2, r8]				; 	BFS[BFS_i] = Right[Source_i]
	CMP r6, #0						; 	IF Right[Source_i] = 0
	BEQ Skip_Right					;		Skip
	
	STR r6, [r3, r5]				; 	Else : Store to BFS[BFS_i]
	ADD r5, r5, #4					; 	BFS_i ++
	
Skip_Right
	ADD r4, r4, #4					; 	Source_i++
	LDR r8, [r3, r4]				; 	BFS[Source_i]
	B BFS_Out
	
;----------------------------------------------------------------------------
Smallest_Start
	LDR r4, =Sorted					; Sorted
;Initialise
	MOV r5, #0						; source_i, source[source_i]
	MOV r6, #0						; bfs_i
	MOV r9, #0						; counter_i
	MOV r11, #0
	SUB r11, #4						; in order to get -4

	LDR r5, [r3]					; source_i = first value in bfs 
	LDR r5, [r0, r5]				; LDR source[source_i]
	STR r5, [r4, #0]				; STR source[source_i] to sorted[i]
	
	ADD r6, r6, #4					; bfs_i++
	ADD r9, r9, #4					; counter_i++
	
Initialise
	MOV r8, r9						; counter = sorted[sorting_i]
	
Compare
	SUB r8, r8, #4					; sorting_i--		//to compare with prev index
	LDR r5, [r3, r5]				; source_i = first value in bfs 
	LDR r5, [r0, r6]				; LDR source[source_i]
	LDR r10, [r4, r8]				; LDR sorted[i]
	CMP r5, r10						; IF source_i GREATER THAN sorted[sorting_i]
	BGT Store						;	Go to Store
	BLT Less_Then					; ELSE IF source_i Less THAN sorted[sorting_i], do to Less_Then

Less_Then
	ADD r8, r8, #4					; Move value[i] to value[i+1]
	STR r10, [r4, r8]
	SUB r8, r8, #4
	CMP r8, r11
	BNE Compare
Store 
	ADD r8, r8, #4					; Store current value to value[i]
	STR r5, [r4, r8]
	ADD r6, r6, #4
	ADD r9, r9, #4
	CMP r9, #60
	BNE Initialise
	
	END