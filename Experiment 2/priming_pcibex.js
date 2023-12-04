PennController.ResetPrefix(null)

// Turn off debugger
DebugOff()

// Control trial sequence

Sequence("welcome","instructions","native_speaker",randomize(rshuffle("experimental_trial","filler_trial")))
,
// Instructions
newTrial("welcome",
    defaultText
        .center()
        .print()
    ,
    newText("welcome-1", "Thank you very much for your participation! This experiment is part of a Cornell University scientific research project. Your decision to complete participant is voluntary. There is no way for us to identify you. The only information we will have, in addition to your responses, is the time at which you completed the survey. The results of the research may be presented at scientific meetings or published in scientific journals. Clicking on the link below indicates that you are at least 18 years of age and agree to complete this experiment voluntarily.")
    ,
    newText("welcome-2","非常感谢您的参与！该实验是康奈尔大学科学研究项目的一部分。您决定是否完成参与是自愿的。除了您的回复之外，我们获得的唯一信息是您完成调查的时间。 研究结果可能会在科学会议上展示或在科学期刊上发表。点击下面的链接表明您已年满 18 周岁并同意自愿完成本实验。")
    ,
    newText("blank","  ")
    ,

    newButton("wait", "Click to see instructions 点击查看实验说明")
        .center()
        .print()
        .wait()
)
,

newTrial("instructions",
    defaultText
        .center()
        .print()
    ,
    newText("instructions-1", "In each trial, you will see two pictures and one sentence. When you see each picture, you need to judge whether the sentence below the picture matches the picture. After judging the sentences corresponding to the two pictures, you will judge whether a sentence that has nothing to do with the picture is correct.")
    ,
    newText("instructions-2","在每次实验中，您会看到两张图片和一个句子。在看到每一张图片时，您需要判断图片下面的句子是否与图片相符，判断完两张图片对应的句子后，您将会判断一张与图片无关的句子是否正确。")
    ,
    newText("no_phone","During the experiment, please make sure to put your phone or other things that might distract you away. Please use Google Chrome is possible. Do not use Safari as error will occur." )
    ,
    newText("nophonecn","在实验过程中，请不要使用手机或其他可能分散您注意力的物品。请尽量使用谷歌浏览器，不要使用Safari.")
    ,
    newText("instructions-3","您将会按键盘选择正确与否。按F选正确，J选不正确。")
    ,
    newText("blank","  ")
    ,

    newButton("wait", "Click to start the experiment 点击开始实验")
        .center()
        .print()
        .wait()
)
,
newTrial("native_speaker",
    defaultText
        .center()
        .print()
    ,
    newText("instr-1",
    "If your native language is Mandarin, please press F. Otherwise please press J.")
    ,
    newText("instr-2",
    "如果您的母语是汉语，请按F，如果不是，请按J。")
    ,
    newText("instr-FJ",
    "F: 汉语母语者 Mandarin native speaker    J: 非汉语母语者 non-native")
    ,
     newKey("keypress", "FJ")
         .wait()
         .log()
    ,
    newVar("nativeSpeaker")
        .global()
        .set(getKey("keypress"))
    )
,

Template("stimuli.csv", row=>
    newTrial("experimental_trial",
    newImage("pic1",row.picture1)
            .size(300,300)
            .center()
            .print()
            ,
    newText("instr1","F:正确      J:错误")
        .center()
        .print()
        .color("grey")
    ,
    newText("blank1","       ")
        .center()
        .print()
    ,
    newText("s1", row.prime1)
        .center()
        .print()
        ,
    
    newKey("keypress1", "FJ")
        .log()
        .wait()

    , 
    getKey("keypress1").remove(),
    getImage("pic1").remove(),
    getText("s1").remove(),
    getText("instr1").remove(),
    
    newImage("pic2",row.picture2)
            .size(300, 300)
            .center()
            .print()
            ,
    newText("instr2","F:正确      J:错误")
        .center()
        .print()
        .color("grey")
    ,
    newText("blank2","       ")
        .center()
        .print()
    ,        
    newText("s2", row.prime2)
            .center()
            .print()
        ,
    newKey("keypress2", "FJ")
        .log()
        .wait()

    , 
    getKey("keypress2").remove(),
    getImage("pic2").remove(),
    getText("s2").remove(),
    getText("instr2").remove(),
    
    newText("instr3","F:正确      J:错误")
        .center()
        .print()
        .color("grey")
    ,
    newText("blank3","       ")
        .center()
        .print()
    ,        
    newText("target", row.target)
            .print()
            .center()
    ,
    newKey("target_response", "FJ")
        .log()
        .wait()
    )
    .log("nativeSpeaker", getVar("nativeSpeaker"))
    .log("space", row.space)
    .log("time", row.time)
    .log("sentence", row.target)
    .log("itemNo",row.itemNo)
    .log("itemType",row.itemType)

)



// fillers

Template("filler_sentences.csv", row=>
    newTrial("filler_trial",
    newImage("pic1",row.picture1)
            .size(300,300)
            .center()
            .print()
            ,
    newText("instr1","F:正确      J:错误")
        .center()
        .print()
        .color("grey")
    ,
    newText("blank1","       ")
        .center()
        .print()
    ,
    newText("s1", row.prime1)
        .center()
        .print()
        ,
    
    newKey("keypress1", "FJ")
        .log()
        .wait()

    , 
    getKey("keypress1").remove(),
    getImage("pic1").remove(),
    getText("s1").remove(),
    getText("instr1").remove(),
    
    newImage("pic2",row.picture2)
            .size(300, 300)
            .center()
            .print()
            ,
    newText("instr2","F:正确      J:错误")
        .center()
        .print()
        .color("grey")
    ,
    newText("blank2","       ")
        .center()
        .print()
    ,        
    newText("s2", row.prime2)
            .center()
            .print()
        ,
    newKey("keypress2", "FJ")
        .log()
        .wait()

    , 
    getKey("keypress2").remove(),
    getImage("pic2").remove(),
    getText("s2").remove(),
    getText("instr2").remove(),
    
    newText("instr3","F:正确      J:错误")
        .center()
        .print()
        .color("grey")
    ,
    newText("blank3","       ")
        .center()
        .print()
    ,        
    newText("target", row.target)
            .print()
            .center()
    ,
    newKey("target_response", "FJ")
        .log()
        .wait()
    )
    .log("nativeSpeaker", getVar("nativeSpeaker"))
    .log("space", row.space)
    .log("time", row.time)
    .log("sentence", row.target)
    .log("itemNo",row.itemNo)
    .log("itemType",row.itemType)

)




