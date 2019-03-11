HW02
===
This is the hw02 sample. Please follow the steps below.

# Build the Sample Program

1. Fork this repo to your own github account.

2. Clone the repo that you just forked.

3. Under the hw02 dir, use:

	* `make` to build.

	* `make clean` to clean the ouput files.

4. Extract `gnu-mcu-eclipse-qemu.zip` into hw02 dir. Under the path of hw02, start emulation with `make qemu`.

	See [Lecture 02 ─ Emulation with QEMU] for more details.

5. The sample is designed to help you to distinguish the main difference between the `b` and the `bl` instructions.  

	See [ESEmbedded_HW02_Example] for knowing how to do the observation and how to use markdown for taking notes.

# Build Your Own Program

1. Edit main.s.

2. Make and run like the steps above.

# HW02 Requirements

1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.  

	Just like how [ESEmbedded_HW02_Example] did.

3. If there are any official data that define the rules, you can also use them as references.

4. Push your repo to your github. (Use .gitignore to exclude the output files like object files or executable files and the qemu bin folder)

[Lecture 02 ─ Emulation with QEMU]: http://www.nc.es.ncku.edu.tw/course/embedded/02/#Emulation-with-QEMU
[ESEmbedded_HW02_Example]: https://github.com/vwxyzjimmy/ESEmbedded_HW02_Example

--------------------

-  **If you volunteer to give the presentation next week, check this.**

--------------------
# HW02 作業心得

1. 實驗題目：
撰寫組合語言觀察其中的變化以及記憶體和sp之間的變化，包括對於pop push sub等操作

2. 實驗步驟：
  - 先將資料夾 gnu-mcu-eclipse-qemu 完整複製到 ESEmbedded_HW02 資料夾中
  - 安裝cross compiler和GNU Debuger for ARM
  - 熟讀ARM ArchitectureReference ManualThumb-2 Supplement
3. 重要手冊資訊
本次作業最重要的是了解關於pop，push等指令在處理器中的影響和sp的變化
- 以push來說：
```
Push Multiple Registers stores a subset (or possibly all) of the general-purpose registers R0-R12 and the LR to the stack.
```
- 以pop來說：
```
Pop Multiple Registers loads a subset (or possibly all) of the general-purpose registers R0-R12 and the PC or the LR from the stack.
```
而push和pop的順序並不會影響，比如說：push{r0,r1,r2,r3}跟push{r1,r2,r3,r0}其結果是一樣的，並且顯示的順序都會和前者相
# 設計main.s 
因為想看暫存器更多的操作所以增加的sub的指令：
```
.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	//
	//mov # to reg
	//
	movs	r0,	#250
	movs	r1,	#250
	movs	r2,	#102
	movs	r3,	#103
	movs    r4, #36
	movs    r5, #36
	movs    r6, #190
	movs    r7, #270
	movs    r8, #300
	movs    r9, #360
    
	// move reg to reg
    movs    r0, r5  //check difference between mov and movs 
	mov     r1, r4

	// sub 
	sub     r1, r2 //r1 =-66
	sub     r4, r5 // r4 =0
    // reset
	movs	r0,	#250
	movs	r1,	#250
	movs	r2,	#102
	movs	r3,	#103


	// push and pop
	//
    push	{r0, r1, r2, r3}
	 // reset
	movs	r0,	#250
	movs	r1,	#250
	movs	r2,	#102
	movs	r3,	#103
	// push and pop
	//
    push	{r1, r2, r0, r3}  //still in compiler is {r0,r1,r2,r3}

	// push and pop
    pop     {r6,r7,r8,r9}   //stack pointer 
    // push and pop
	pop     {r8,r7,r9,r6}  //stack pointer getting bigger but still in compiler {r6,r7,r8,r9}
```

## push

我們給予r0~r9整數值進行測試，以push{r0,r1,r2,r3}為例，sp由0x20000100轉為0x20000f0，因為每個暫存器記憶體大小為4bits，psuh4個暫存器後，其sp壓縮了16個bits，如圖：
**push前**
![image](https://github.com/GOGOGOGOGOGOG/ESEmbedded_HW02/blob/master/2019-03-11%2018-10-58%20%E7%9A%84%E8%9E%A2%E5%B9%95%E6%93%B7%E5%9C%96.png)
**push後**
![image](https://github.com/GOGOGOGOGOGOG/ESEmbedded_HW02/blob/master/2019-03-11%2018-12-03%20%E7%9A%84%E8%9E%A2%E5%B9%95%E6%93%B7%E5%9C%96.png)

而在push的順序改變下，以處理器來看依舊是沒有變化的，如圖:
![image](https://github.com/GOGOGOGOGOGOG/ESEmbedded_HW02/blob/master/2019-03-11%2018-22-11%20%E7%9A%84%E8%9E%A2%E5%B9%95%E6%93%B7%E5%9C%96.png)

## pop
我們給予r0~r9整數值進行測試，以push{r6,r7,r8,r9}為例，其因為pop掉4個暫存器的記憶體大小，故由0x200000e0變為0x200000f0，而因為push和pop性質相同，順序亦不影響sp表現的行為，如圖：
**pop前**
![image](https://github.com/GOGOGOGOGOGOG/ESEmbedded_HW02/blob/master/2019-03-11%2018-24-47%20%E7%9A%84%E8%9E%A2%E5%B9%95%E6%93%B7%E5%9C%96.png)

**pop後**
![image](https://github.com/GOGOGOGOGOGOG/ESEmbedded_HW02/blob/master/2019-03-11%2018-27-42%20%E7%9A%84%E8%9E%A2%E5%B9%95%E6%93%B7%E5%9C%96.png)
# 作業心得
本次作業了解到原來gdb還能使用在組合語言上面，並且除了可以跟valgrind結合幫程式碼debug以外還能跟qemu一起使用來觀察記憶體操作的行為，之後會再針對組合語言和gdb的操作去做更多的認識和撰寫。





