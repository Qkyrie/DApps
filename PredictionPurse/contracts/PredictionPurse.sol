contract PredictionPurse {

    enum Stages {
        NO_STATEMENT,
        VOTING_ALLOWED,
        STATEMENT_RESOLVED
    }

  struct Vote {
     bool vote;
     address voter;
     uint amount;
  }


  Stages public stage = Stages.NO_STATEMENT;
  string statement;
  bool outcome;
  Vote[] public votes;
  uint numVoters;
  address public owner;

  modifier onlyOwner() {
    if (msg.sender != owner) throw;
    _
  }

  modifier atStage(Stages _stage) {
    if (stage != _stage) throw;
    _
  }

  function PredictionPurse {
      owner = msg.sender;
  }

  function createStatement(String _statement) onlyOwner onlyStage(Stages.NO_STATEMENT) {
      //create statement
      statement = _statement;
      stage = Stages.VOTING_ALLOWED;
  }

  function createOutcome(bool _outcome) onlyOwner onlyStage(Stages.VOTING_ALLOWED) {
      outcome = _outcome;
      stage = Stages.STATEMENT_RESOLVED;
  }

  function vote(bool yesno) onlyStage(Stages.VOTING_ALLOWED) {
    votes.push(
      Vote({ vote: yesno, amount: msg.value, voter: msg.sender })
    );
  }

  function payout() onlyStage(Stages.STATEMENT_RESOLVED) {
    //do payout
    uint counter = 0;
    while(counter < votes.length) {
      Vote v = votes[counter];
      if(v.vote == outcome && !v.voter.send(v.amount)) {
         throw;
      }
      delete votes[counter];
      counter++;
    }
    delete numVotes;
    delete votes;
    delete statement;
    stage = Stages.NO_STATEMENT;
  }


  //fallback function doesn't exist
  function() {
   throw;
  }
}
