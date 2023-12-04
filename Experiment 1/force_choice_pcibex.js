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
    newText("instructions-1", "In each trial, you will see two sentences on the screen, and you will be asked to decide which sentence is more acceptable.")
    ,
    newText("instructions-2","在每次试验中，您都会在屏幕上看到两个句子，系统会要求您决定哪个句子更容易接受。")
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


    Template("experimental.csv", row =>
    newTrial("experimental_trial",
    newText("instr",
    "下面哪个句子更可接受？按F选上面的句子，按J选下面的句子。"
    )
    .center()
    .print()
    .bold()
    ,
    newText("blank","    ")
    .center()
    .print()
    .print()
    ,
    
    newText("ver", row.sentence_ver)
    .print()
    ,
    newText("hor",row.sentence_hor)
    .print()
    ,
    newCanvas("side-by-side",1400,200)
        .add(250,0,getText("ver"))
        .add(250,50,getText("hor"))
        .center()
        .print()
        .log()
    ,
    newSelector("selection")
            .add(getText("ver"), getText("hor"))
            .shuffle()
            .keys("F", "J")
            .wait()
            .log()
    ,
    newKey("keypress", "FJ")
        .log()
        .wait()
    )
     .log("Native_speaker", getVar("nativeSpeaker"))
     .log("time", row.time)
     .log("itemNo.",row.item)
    //  .log("is_filler",row.is_filler)
    
    )
    ,
    
Template("filler.csv", row =>
    newTrial("filler_trial",
    newText("instr",
    "下面哪个句子更可接受？按F选上面的句子，按J选下面的句子。"
    )
    .center()
    .print()
    .bold()
    ,
    newText("blank","    ")
    .center()
    .print()
    .print()
    ,
    
    newText("grammatical", row.grammatical)
    .print()
    ,
    newText("ungrammatical",row.ungrammatical)
    .print()
    ,
    newCanvas("side-by-side",1400,200)
        .add(250,0,getText("grammatical"))
        .add(250,50,getText("ungrammatical"))
        .center()
        .print()
        .log()
    ,
    newSelector("selection")
            .add(getText("grammatical"), getText("ungrammatical"))
            .shuffle()
            .keys("F", "J")
            .wait()
            .log()
    ,
    newKey("keypress", "FJ")
        .log()
        .wait()
    
    )
    // .log("Native_speaker", getVar("nativeSpeaker"))
    .log("itemNo.",row.item)
//     .log("is_filler",row.is_filler)
    )
    
    
// ,
// newTrial("Comments",
//     defaultText
//         .center()
//         .print()
//     ,
//     newText("instr-1",
//     "请留下您对此实验的建议，这将对我们有很大的帮助。感谢您的参与！")
//     ,
//     newText("instr-2",
//     "Please leave suggestions and comments for this experiment. This would help us a lot. Thank you for your participation!")
//     ,
//     newTextInput("Comments")
//         .center()
//         .print()
//     ,
//     newVar("Comments_from_participants")
//         .global()
//         .set(getTextInput("Comments"))
//     ,
//     newButton("wait", "Click to submit your comments")
//         .center()
//         .print()
//         .wait()
// )
// .log("Comments", getVar("Comments_from_participants"))

// Template("items.csv", row =>
//     newTrial("all_trial",
//     newText("instr",
//     "下面哪个句子更可接受？按F选上面的句子，按J选下面的句子。"
//     )
//     .center()
//     .print()
//     .bold()
//     ,
//     newText("blank","    ")
//     .center()
//     .print()
//     .print()
//     ,
    
//     newText("ver/gra", row.sentence_ver)
//     .print()
//     ,
//     newText("hor/ungra",row.sentence_hor)
//     .print()
//     ,
//     newCanvas("side-by-side",1400,200)
//         .add(250,0,getText("ver/gra"))
//         .add(250,50,getText("hor/ungra"))
//         .center()
//         .print()
//         .log()
//     ,
//     newSelector("selection")
//             .add(getText("ver/gra"), getText("hor/ungra"))
//             .shuffle()
//             .keys("F", "J")
//             .wait()
//             .log()
//     ,
//     newKey("keypress", "FJ")
//         .log()
//         .wait()
//     // ,
//     // newVar("time",row.time)
//     //     .log()
        
//     // ,
//     // newVar("itemNo.", row.item)
//     // .log()
    
    
//     )
//     .log("Native_speaker", getVar("nativeSpeaker"))
//     .log("time", row.time)
//     .log("itemNo.",row.item)
//     .log("is_filler",row.is_filler)
    
//     )
    


    
    
    