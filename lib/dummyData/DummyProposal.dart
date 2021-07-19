import 'package:flutter/material.dart';

class DummyProposal with ChangeNotifier {
  String ProposalTopic = null;
  int ProposalPrice = null;
  String ProposalStart = null;
  String ProposalEnd = null;

  List<String> ProposalTags = [];

  void ChangeProposalTopic(String value){
    ProposalTopic = value;
    notifyListeners();
  }
  void ChangeProposalPrice(int value){
    ProposalPrice = value;
    notifyListeners();
  }
  void ChangeProposalStart(String value){
    ProposalStart = value;
    notifyListeners();
  }
  void ChangeProposalEnd(String value){
    ProposalEnd = value;
    notifyListeners();
  }

  void AddProposalTags(String value){
    ProposalTags.add(value);
    notifyListeners();
  }
  void RemoveProposalTags(int index){
    ProposalTags.removeAt(index);
    notifyListeners();
  }
}