//
//  Copyright 2011  U.S. Centers for Disease Control and Prevention
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "DataController.h"
#import "DecisionTree.h"
#import "DTNode.h"
#import "DTConnector.h"
#import "AppManager.h"


// these macros assume the variables 
#define CURRENT_TREE_NUM currTreeNum
#define CURRENT_TREE newTree
#define CURRENT_NODE newNode
#define CURRENT_FOOTNOTE newFootnote
#define CURRNET_FOOTNOTE_TREE newFootnoteCollection

#define ADD_TREE(tree_name, group_name, tree_num) CURRENT_TREE=[self loadTreeWithName:@tree_name groupName:@group_name number:tree_num];CURRENT_TREE_NUM=tree_num   

#define ADD_NODE(node_text, node_num) CURRENT_NODE=[self loadNodeWithText:@node_text tree:CURRENT_TREE nodeNumber:node_num]
#define ADD_EXIT(text, exit_tree, exit_node) [CURRENT_NODE  addExitConnectorWithText:@text exitTree:exit_tree exitNode:exit_node]

// adds a node with a Yes, No decision options to the current tree where both the Yes and No nodes tree numbers have to be specified
#define ADD_NODE_DECISION(node_text, node_num, option1_text, option1_node, option2_text, option2_node) \
        ADD_NODE(node_text, node_num); ADD_EXIT(option1_text, CURRENT_TREE_NUM, option1_node);ADD_EXIT(option2_text, CURRENT_TREE_NUM, option2_node) 

#define ADD_NODE_DECISION_EXPLICIT(node_text, node_num, option1_text,  option1_tree, option1_node, option2_text,  option2_tree, option2_node) \
ADD_NODE(node_text, node_num); ADD_EXIT(option1_text, option1_tree, option1_node); ADD_EXIT(option2_text, option2_tree, option2_node) 

#define ADD_FOOTNOTE(footnote_text) [CURRENT_TREE addFootnote:@footnote_text]
#define ADD_FOOTNOTE_ID(footnote_id) [CURRENT_NODE addFootnoteId:[NSNumber numberWithInt:((footnote_id) - 1)]]

// adds a node with a Yes, No decision options to the current tree where both the Yes and No nodes tree numbers have to be specified
#define ADD_NODE_YES_NO_EXPLICIT(node_text, node_num, yes_tree, yes_node, no_tree, no_node) newNode = \
[self loadYesNoNodeWithText:@node_text tree:CURRENT_TREE nodeNumber:node_num \
yesTreeNumber:yes_tree yesNodeNumber:yes_node noTreeNumber:no_tree noNodeNumber:no_node]

// adds a node with a Yes, No decision options to the current tree where both the Yes and No nodes are in current tree
#define ADD_NODE_YES_NO(node_text, node_num, yes_node, no_node) newNode = \
[self loadYesNoNodeWithText:@node_text tree:CURRENT_TREE nodeNumber:node_num \
yesTreeNumber:CURRENT_TREE_NUM yesNodeNumber:yes_node noTreeNumber:CURRENT_TREE_NUM noNodeNumber:no_node]

// adds a node with a Continue exit to current tree where Continue exit node tree number has to be specified
#define ADD_NODE_CONTINUE_EXPLICIT(node_text, node_num, continue_tree, continue_node) newNode = \
[self loadContinueNodeWithText:@node_text tree:CURRENT_TREE nodeNumber:node_num \
exitTreeNumber:continue_tree exitNodeNumber:continue_node] 

// adds a node with a Continue exit to current tree where Continue exit node tree number has to be specified
#define ADD_NODE_CONTINUE(node_text, node_num, continue_node) newNode = \
[self loadContinueNodeWithText:@node_text tree:CURRENT_TREE nodeNumber:node_num \
exitTreeNumber:CURRENT_TREE_NUM exitNodeNumber:continue_node];


#define AS_STMT_NODE() [CURRENT_NODE asStatementNode]
#define AS_EVAL_NODE() [CURRENT_NODE asEvalNode]
#define AS_LAST_NODE() [CURRENT_NODE asLastNode]
#define AS_FOOTNOTE_NODE() [CURRENT_NODE asFootnoteNode]
#define AS_ROOT_NODE() self.currDecisionTree = newTree;self.currDecisionNode = newNode;self.startingTree = newTree;self.startingNode = newNode;[CURRENT_NODE asRootNode]


@implementation DataController

@synthesize allTrees, currPatientEncounter, currDecisionTree, currDecisionNode;
@synthesize startingNode, startingTree, visitedNodes;

AppManager *appMgr;

-(id)init
{
    
    if( (self = [super init]) ) {
        allTrees = [[DecisionTrees alloc] init];
        self.currPatientEncounter = nil;
        self.currDecisionTree = nil;
        self.currDecisionNode = nil;
        [self loadDecisionTrees];

        visitedNodes = [[VisitedDecisionNodes alloc] init];        
        appMgr = [AppManager singletonAppManager];
        
    }
    
    return self;
}


// 
-(PatientEvaluation *)createPatientEncounter
{
    
    currPatientEncounter = [[PatientEvaluation alloc] init];
    return currPatientEncounter;
    
}

-(DTNode *)getRootNode
{
    
    return self.startingNode;
    
}


// find the next node
-(DTNode *)goToNodeUsingConnector:(DTConnector *)chosenConnector
{

    NodeId *nextNodeId = [chosenConnector getNextNodeId];
    DecisionTree *nextTree = [self.allTrees getTreeWithNumber:nextNodeId.treeNumber];
    self.currDecisionNode = [nextTree getNodeForNodeId:nextNodeId];
    self.currDecisionTree = [self.allTrees getTreeWithNumber:self.currDecisionNode.nodeId.treeNumber];
    return self.currDecisionNode;
    
}


-(void)restartPatientEvaluation
{

    self.currDecisionNode = self.startingNode;
    self.currDecisionTree = self.startingTree;
    [self.currPatientEncounter restart];
    [visitedNodes restart];
    
}

-(DecisionTree *)loadTreeWithName:(NSString *)newTreeName 
                        groupName:(NSString *)newGroupName 
                           number:(NSUInteger)newTreeNumber
{
    
    DecisionTree *newTree = [[DecisionTree alloc] initWithName:newTreeName groupName:newGroupName number:newTreeNumber];
    [self.allTrees addTree:newTree];
    return newTree;
    
}

-(DTNode *)loadNodeWithText:(NSString *)bodyText tree:(DecisionTree *)newTree nodeNumber:(NSUInteger)newNodeNumber
{
    
    DTNode *newNode = [[DTNode alloc] initWithBodyText:bodyText tree:newTree nodeNumber:newNodeNumber];
    [self.allTrees addNode:newNode toTree:newTree];
    return newNode;
    
    
}


-(DTNode *)loadContinueNodeWithText:(NSString *)bodyText 
                               tree:(DecisionTree *)aTree 
                         nodeNumber:(NSUInteger)newNodeNumber
                       exitTreeNumber:(NSUInteger)aTreeNumber
                         exitNodeNumber:(NSUInteger)aNodeNumber 

{
    
    DTNode *newNode = [[DTNode alloc] initWithBodyText:bodyText tree:aTree nodeNumber:newNodeNumber];
    [newNode addExitConnectorWithText:@"Continue" exitTree:aTreeNumber exitNode:aNodeNumber];
    [self.allTrees addNode:newNode toTree:aTree];
    return newNode;
    
}


-(DTNode *)loadYesNoNodeWithText:(NSString *)bodyText 
                            tree:(DecisionTree *)newTree 
                      nodeNumber:(NSUInteger)newNodeNumber
                   yesTreeNumber:(NSUInteger)newYesTreeNumber
                   yesNodeNumber:(NSUInteger)newYesNodeNumber
                    noTreeNumber:(NSUInteger)newNoTreeNumber
                    noNodeNumber:(NSUInteger)newNoNodeNumber
{
    
    DTNode *newNode = [[DTNode alloc] initWithBodyText:bodyText tree:newTree nodeNumber:newNodeNumber];
    [newNode addExitConnectorWithText:@"Yes" exitTree:newYesTreeNumber exitNode:newYesNodeNumber];
    [newNode addExitConnectorWithText:@"No" exitTree:newNoTreeNumber exitNode:newNoNodeNumber];
    [self.allTrees addNode:newNode toTree:newTree];
    return newNode;
    
    
}

// load test data
-(void)loadDecisionTrees
{
    
    DecisionTree *newTree;
    DTNode *newNode;
    NSUInteger currTreeNum = 0;
    
    // application has it's own tree that prompts user, it's tree number = 0;
    // all trees should have a first node number of 1
    ADD_TREE("PTT Advisor Algorithm", "Describe Your Patient", 1);
    ADD_NODE_YES_NO("Does the patient have prolonged PTT and normal PT?", 1, 2, 3);
    AS_ROOT_NODE();
    AS_EVAL_NODE();
    ADD_NODE_YES_NO_EXPLICIT("Is the patient older than 6 months?", 2, 2, 1, 3, 1);
    ADD_NODE("There is currently no algorithm for a patient meeting this criteria.", 3);
    AS_LAST_NODE();

    
    // PTT Adult algorithm 
    ADD_TREE("Adult", "Evaluation Guide", 2);
    
    // add first node and it's exit connectors to tree
    ADD_NODE_CONTINUE("Rule out presence of heparin and LMWH – by history, by performing a PTT after treating plasma with a heparin degrading enzyme, or by performing a thrombin time (LMWH may not prolong thrombin time). [see footnotes]", 1, 2);
    ADD_FOOTNOTE_ID(1);
    ADD_FOOTNOTE_ID(2);
    AS_FOOTNOTE_NODE();
    AS_STMT_NODE();
    ADD_NODE_YES_NO("Is there a complete or near complete correction in an incubated PTT mixing study? [see footnotes]", 2, 3, 12);
    ADD_FOOTNOTE_ID(3);
    AS_FOOTNOTE_NODE();
    AS_EVAL_NODE();
    ADD_NODE_YES_NO("Is there recent onset or recently diagnosed bleeding? [see footnotes]", 3, 4, 5);
    AS_EVAL_NODE();
    ADD_FOOTNOTE_ID(4);
    AS_FOOTNOTE_NODE();
    ADD_NODE_YES_NO("Do the levels of factors VIII, IX, or XI reflect a deficiency? [see footnotes]", 4, 7, 6);
    AS_EVAL_NODE();
    ADD_FOOTNOTE_ID(5);
    ADD_FOOTNOTE_ID(6);
    AS_FOOTNOTE_NODE();
    ADD_NODE_YES_NO("Does the level of factor XII reflect a deficiency? [see footnotes]", 5, 8, 9);
    ADD_FOOTNOTE_ID(8);
    AS_FOOTNOTE_NODE();
    AS_EVAL_NODE();
    ADD_NODE("The bleeding is most likely unrelated to the prolonged PTT. Consider causes such as thrombocytopenia, platelet function defect, scurvy, Ehlers-Danlos syndrome, etc.", 6);
    AS_LAST_NODE();
    ADD_NODE("The PTT is most likely explained by an intrinsic factor deficiency. Factors VIII and IX deficiencies are X-linked but female carriers may present with bleeding. Factor XI deficiency is not X-linked. If factor VIII is low in a female, consider von Willebrand disease (VWD) – order tests for VWD. [see footnotes]", 7);
    ADD_FOOTNOTE_ID(7);
    AS_FOOTNOTE_NODE();
    AS_LAST_NODE();
    ADD_NODE("The PTT is most likely explained by factor XII deficiency. [see footnotes]", 8);
    ADD_FOOTNOTE_ID(9);
    AS_FOOTNOTE_NODE();
    AS_LAST_NODE();
    ADD_NODE_YES_NO("Is there interest in identifying rare factor deficiencies?", 9, 10, 11);
    AS_EVAL_NODE();
    ADD_NODE("Check activity levels of prekallikrein or HMWK. [see footnotes]", 10);
    ADD_FOOTNOTE_ID(10);
    AS_FOOTNOTE_NODE();
    AS_LAST_NODE();
    ADD_NODE("Further testing is required to determine if the prolonged PTT is due to rare factor deficiencies.", 11);
    AS_LAST_NODE();
    ADD_NODE_YES_NO("Is there recent onset or recently diagnosed bleeding? [see footnotes]", 12, 13, 14);
    AS_EVAL_NODE();
    ADD_FOOTNOTE_ID(4);
    AS_FOOTNOTE_NODE();
    ADD_NODE_YES_NO("Does the level of factor VIII reflect a deficiency?", 13, 15, 14);
    AS_EVAL_NODE();
    ADD_NODE_YES_NO("Are the tests for lupus anticoagulant (LA) positive? [see footnotes]", 14, 16, 17);
    ADD_FOOTNOTE_ID(12);
    ADD_FOOTNOTE_ID(13);
    AS_FOOTNOTE_NODE();
    AS_EVAL_NODE();
    ADD_NODE_CONTINUE("The prolonged PTT is most likely explained by an acquired factor VIII deficiency due to an inhibitor. [see footnotes]", 15, 18);
    ADD_FOOTNOTE_ID(11);
    AS_FOOTNOTE_NODE();
    AS_STMT_NODE();
    ADD_NODE("The prolonged PTT is most likely due to a LA.", 16);
    AS_LAST_NODE();
    ADD_NODE_YES_NO("Are repeat tests for LA positive?", 17, 16, 19);
    AS_EVAL_NODE();
    ADD_NODE("Determine the Bethesda titer of the factor VIII inhibitor to establish a semiquantitative antifactor VIII concentration.", 18);
    AS_LAST_NODE();
    ADD_NODE("Causes of false negative tests for LA include a weak antibody, high factor VIII, or platelet count greater than 10,000/microliter in a frozen plasma specimen because platelet phospholipids may neutralize LA. If there is strong clinical suspicion, repeat LA testing at a later date.", 19);
    AS_LAST_NODE();
    
    // add footnotes to current tree
    ADD_FOOTNOTE("If available, order an anti-Xa assay to detect and quantitate heparin or low molecular heparin (LMWH).");
    ADD_FOOTNOTE("Low molecular weight heparins (LMWH) do not consistently prolong the PTT.  The effect is variable even using the same PTT reagent.");  
    ADD_FOOTNOTE("A mixing study may be difficult to interpret when the PTT is less than 5 seconds above the reference range. Concurrent testing for lupus anticoagulant (LA) and factors XI and XII may be informative. The definition of correction in the PTT mixing study is not uniformly defined. Commonly used targets include a PTT value of the mix in the reference range, within 5 seconds or 10% of the normal plasma result. The mixing study of patients with weak LA may show correction and not reveal the inhibitor. Clinical correlation will help suspect LA.");
    ADD_FOOTNOTE("Unexplained bleeding may or may not be related to the prolonged PTT.");
    ADD_FOOTNOTE("A possibility for false PTT prolongation is degradation of factor VIII in vitro during handling or transport of the blood sample. A repeat PTT with a freshly collected specimen may be useful to show the true result.");
    ADD_FOOTNOTE("The bleeding severity in factors VIII or IX deficiency (hemophilia A and B) is directly related to the factor level (severe < 1%, moderate 1-5%, mild >5%). Approximately 30% of hemophiliacs have spontaneous new mutations, with negative family histories. Guidelines for the Management of Hemophilia published by the World Federation of Hemophilia may be found in this link: http://bit.ly/sQafEv. Factor XI deficiency is associated with bleeding in areas of high fibrinolytic activity such as mouth or urinary tract but may also be asymptomatic. Personal or family history of bleeding is informative to identify patients at risk of bleeding. Factor XI deficiency is present in 4% of Ashkenazi Jews but can be present in any ethnic group.");
    ADD_FOOTNOTE("Von Willebrand disease (vWD) is diagnosed with assays for von Willebrand factor (vWF) antigen and activity, and factor VIII. vWD may be due to a quantitative deficiency (types 1 and 3) or qualitative abnormalities in the vWF molecule (type 2 which has multiple subtypes). Since vWF transports factor VIII in the circulation, the PTT may be prolonged if factor VIII is significantly decreased with vWF. It is recommended to interpret a patient’s result based on the expected level for his/her blood type. Type 2N vWD is an autosomal recessive disorder caused by a mutation in vWF which leads to decreased binding and increased proteolysis of factor VIII in the circulation. Acquired vWD may also be considered. Depending on the age of the patient, it may be difficult to differentiate congenital from acquired vWD. The distinction is aided by review of family history and evaluation for the presence of underlying conditions such as multiple myeloma, lymphoproliferative malignancies, mitral valve prolapse, hypothyroidism, and several drugs, which are associated with acquired VWD. The National Institutes of Health has recently published a comprehensive review of the diagnosis and management of patients with vWD (Am J Hematol. 2009 Jun;84(6):366-70).");
    ADD_FOOTNOTE("Mild to moderate deficiencies of factors VIII, IX and XI may be asymptomatic, particularly in the patient who has never had a surgical procedure where he/she could have bled. However, since factor XII deficiency is more common, it should be first excluded in patients without a history of bleeding. If the factor XII is normal, consider measuring factors VIII, IX and XI levels.");
    ADD_FOOTNOTE("Patients with factor XII deficiency do not require transfusion to prevent bleeding, even if surgery is anticipated. Transient factor XII deficiency may be seen in patients awaiting tonsillectomy.");
    ADD_FOOTNOTE("Prekallikrein (Fletcher factor), and HMWK (Fitzgerald factor) are contact factors with a poorly understood physiologic role in coagulation. Even severe deficiencies of these proteins are not associated with bleeding. The prekallikrein screening assay is a PTT with a prolonged incubation time. Quantitative assays for prekallikrein and HMWK are only commonly available from reference laboratories.");
    ADD_FOOTNOTE("Acquired hemophilia must be suspected in elderly individuals with negative bleeding history who suddenly develop soft tissue hematomas and/or persistent and significant gastrointestinal or genitourinary hemorrhage. This is a rare but serious autoimmune bleeding disorder which has also been described in pregnancy or the post-partum period. Prompt diagnosis of acquired hemophilia is imperative because the treatment requires factor concentrates such as recombinant factor VIIa or activated prothrombin complex concentrates, since plasma is ineffective.");
    ADD_FOOTNOTE("Laboratories should use at least two screening assays for LA due to the heterogeneity of this antibody. A prolonged result in one or both screening assays should be followed by a mixing study and confirmatory tests.");
    ADD_FOOTNOTE("Lupus anticoagulant (LA) is an antibody that binds to a plasma protein (Beta2 glycoprotein 1). In vitro, it prolongs clot-based tests such as the PTT; in vivo, on the other hand, the LA is strongly thrombophilic. LA may be transiently present or may indicate antiphospholipid syndrome, the most common acquired cause of hypercoagulability. The diagnosis of antiphospholipid syndrome requires two positive tests for an antiphospholipid antibody (such as LA) at least 12 weeks apart, in the setting of thrombosis or recurrent fetal loss (J Thromb Haemost. 2009 Oct;7(10):1737-40). When the LA test is positive, it may cause falsely low coagulation factor activities, which may lead to the incorrect diagnosis of factor deficiency(ies).");
    
    
    // new tree
    // create PTT child algorithm tree
    ADD_TREE("Child", "Evaluation Guide", 3);
    
    // add first node and it's exit connectors to tree
    ADD_NODE_CONTINUE("Rule out presence of heparin and LMWH – by history, by performing a PTT after treating plasma with a heparin degrading enzyme, or by performing a thrombin time (LMWH may not prolong thrombin time). [see footnotes]", 1, 2);
    AS_STMT_NODE();
    ADD_FOOTNOTE_ID(1);
    ADD_FOOTNOTE_ID(2);
    AS_FOOTNOTE_NODE();
    ADD_NODE_DECISION("Is the child male or female?", 2, "Male", 3, "Female", 13);
    AS_EVAL_NODE();
    ADD_NODE_YES_NO("Do the levels of factors VIII or IX reflect a deficiency? [see footnotes]", 3, 4, 5);
    AS_EVAL_NODE();
    ADD_FOOTNOTE_ID(3);
    ADD_FOOTNOTE_ID(4);
    ADD_FOOTNOTE_ID(5);
    AS_FOOTNOTE_NODE();
    ADD_NODE_CONTINUE("The bleeding severity in factors VIII (hemophilia A) or factor IX (hemophilia B) deficiency is directly related to the factor level (severe < 1%, moderate 1-5%, mild >5%). [see footnotes]", 4, 17);
    AS_STMT_NODE();
    ADD_FOOTNOTE_ID(6);
    ADD_FOOTNOTE_ID(7);
    AS_FOOTNOTE_NODE();
    ADD_NODE_YES_NO("Does the level of factor XII reflect a deficiency? [see footnotes]", 5, 6, 7);
    AS_EVAL_NODE();
    ADD_FOOTNOTE_ID(8);
    AS_FOOTNOTE_NODE();
    ADD_NODE("The PTT is most likely explained by factor XII deficiency.", 6);
    AS_LAST_NODE();
    ADD_NODE_YES_NO("Is the child is less than 30 days old?", 7, 8, 9);
    AS_EVAL_NODE();
    ADD_NODE_YES_NO("Could the mother have a LA? [see footnotes]", 8, 10, 9);
    AS_EVAL_NODE();
    ADD_FOOTNOTE_ID(9);
    AS_FOOTNOTE_NODE();
    ADD_NODE_YES_NO("Is there interest in identifying rare factor deficiencies in the child?", 9, 11, 12);
    AS_EVAL_NODE();
    ADD_NODE("Order tests for LA in the mother and the baby. LA is an IgG that crosses the placenta and can cause prolonged PTT in the child for a few weeks after birth. [see footnotes]", 10);
    AS_LAST_NODE();
    ADD_FOOTNOTE_ID(10);
    AS_FOOTNOTE_NODE();
    ADD_NODE("Check activity levels of prekallikrein and HMWK. [see footnotes]", 11);
    AS_LAST_NODE();
    ADD_FOOTNOTE_ID(11);
    AS_FOOTNOTE_NODE();
    ADD_NODE("Further testing is required to determine if the prolonged PTT is due to rare factor deficiencies.", 12);
    AS_LAST_NODE();
    ADD_NODE_YES_NO("Do the levels of factors VIII or XII reflect a deficiency? [see footnotes]", 13, 14, 15);
    AS_EVAL_NODE();
    ADD_FOOTNOTE_ID(3);
    ADD_FOOTNOTE_ID(4);
    ADD_FOOTNOTE_ID(6);
    ADD_FOOTNOTE_ID(7);
    ADD_FOOTNOTE_ID(12);
    AS_FOOTNOTE_NODE();
    ADD_NODE("The PTT is most likely explained by factor VIII (hemophilia A) carrier state, factor XII deficiency, or vWD.", 14);
    AS_LAST_NODE();
    ADD_NODE_YES_NO("Does the level of factor IX reflect a deficiency? [see footnotes]", 15, 16, 7);
    AS_EVAL_NODE();
    ADD_FOOTNOTE_ID(12);
    AS_FOOTNOTE_NODE();
    ADD_NODE("The PTT is most likely explained by factor IX (hemophilia B) carrier state.", 16);
    AS_LAST_NODE();
    ADD_NODE("Approximately 30% of hemophiliacs have spontaneous new mutations, with negative family histories. Consider the possibility of von Willebrand disease (vWD) by ordering specific tests for this condition.",17);
    AS_LAST_NODE();
    
    ADD_FOOTNOTE("If available, order an anti-Xa assay to detect and quantitate heparin or low molecular heparin (LMWH).");
    ADD_FOOTNOTE("Low molecular weight heparins (LMWH) do not consistently prolong the PTT. The effect is variable even using the same PTT reagent.");
    ADD_FOOTNOTE("A possibility for false PTT prolongation is degradation of factor VIII in vitro during handling or transport of the blood sample. A repeat PTT with a freshly collected specimen may be useful to show the true result.");
    ADD_FOOTNOTE("While most coagulation factors are expected to be lower in children less than 6 months of age compared with adult reference ranges, factor VIII and vWF are exceptions. Selected reference ranges for neonates are: factor VIII: 50-178% (term) and 50-213% (premature); vWF: 50-287% (term) and 78-210% (premature); factor IX: 15-91% (term) and 19-65% (premature); and factor XI:10-66% (term) and 8-52% (premature). Guidelines for the Management of Hemophilia published by the World Federation of Hemophilia may be found in this link: http://bit.ly/sQafEv.");
    ADD_FOOTNOTE("Mild to moderate deficiencies of factors VIII and IX may be asymptomatic, particularly in the patient who has never had a surgical procedure where he/she could have bled.");
    ADD_FOOTNOTE("Since Von Willebrand factor (vWF) carries factor VIII in the circulation, low factor VIII may be seen in von Willebrand disease (vWD) as well. vWD may be difficult to diagnose in young children due to higher expected level of vWF compared with that of adults (see footnote 4) and Am J Clin Pathol. 2005 Jun;123 Suppl:S119-24. vWD may be due to a quantitative deficiency (types 1 and 3) or qualitative abnormalities in the vWF molecule (type 2 which has multiple subtypes). vWD is diagnosed with assays for von Willebrand factor (vWF) antigen and activity, and factor VIII. A rare type of vWD, 2N, is caused by a mutation in vWF which leads to decreased binding and increased proteolysis of factor VIII in the circulation. The National Institutes of Health has recently published a comprehensive review of the diagnosis and management of patients with vWD (Am J Hematol. 2009 Jun;84(6):366-70).");
    ADD_FOOTNOTE("Acquired hemophilia in the mother may decrease the factor VIII in the child through passive transfer of the factor VIII antibody.");
    ADD_FOOTNOTE("Factor XII deficiency is more common than hemophilia A or B (deficiencies in factor VIII or IX, respectively). Thus, it may be excluded first in patients without a history of bleeding. Patients with factor XII deficiency do not require transfusion to prevent bleeding, even if surgery is anticipated. Transient factor XII deficiency may be seen in patients awaiting tonsillectomy.");
    ADD_FOOTNOTE("Lupus anticoagulant (LA) is an antibody that binds to a plasma protein (Beta2 glycoprotein 1). In vitro, it prolongs clot-based tests such as the PTT; in vivo, on the other hand, the LA is strongly thrombophilic. LA may be transiently present it may indicate antiphospholipid syndrome, the most common acquired cause of hypercoagulability. The diagnosis of antiphospholipid syndrome in the mother requires two positive tests for an antiphospholipid antibody (such as LA) at least 12 weeks apart, in the setting of thrombosis or recurrent fetal loss (J Thromb Haemost. 2009 Oct;7(10):1737-40). When the LA test is positive, it may cause falsely low coagulation factor activities, which may lead to the incorrect diagnosis of factor deficiency(ies).");
    ADD_FOOTNOTE("Laboratories should use at least two screening assays for LA. A prolonged result in one or both screening assays should be followed by a mixing study and confirmatory tests. A positive LA in a child is not considered clinically significant and the antibody is expected to disappear over a couple of weeks.");
    ADD_FOOTNOTE("Prekallikrein (Fletcher factor), and HMWK (Fitzgerald factor) are contact factors with a poorly understood physiologic role in coagulation. Even severe deficiencies of these proteins are not associated with bleeding. The prekallikrein screening assay is a PTT with a prolonged incubation time. Quantitative assays for prekallikrein and HMWK are only commonly available from reference laboratories.");
    ADD_FOOTNOTE("In females, a low factor VIII may be due to vWD (see footnote 6). Decreased levels of factors VIII or IX in females are expected in carriers. These patients may be asymptomatic or have a history of bleeding during hemostatic challenges such as surgery or trauma.");
    
}


@end
