import React from "react";
import eloConsts from "../../static/elo-consts.json";

import newScorePng from "../../static/formula/new-score.png";
import expectedOddsPng from "../../static/formula/expected-odds.png";
import expectedOddsQPng from "../../static/formula/expected-odds-q.png";
import multiPersonOddsPng from "../../static/formula/multi-person-odds.png";
import tagTeamOddsPng from "../../static/formula/tag-team-odds.png";

import "./faq.styl";

const Faq = () => {
  return (
    <div className="faq">
      <h2>FAQ</h2>
      <React.Fragment>
        <h3>Calculating Elos</h3>
        <div className="plain-text">
          {`All wrestlers start with an elo of ${
            eloConsts.default_elo
          }. After each match all participants of the match will get their elo updated:`}
          <div className="formula">
            <img src={newScorePng} />
          </div>
          {`where K is the K-factor and S and E are the actual and expected scores
          of the match for that participant. The K-factor (K), or match weight,
          is the maximum amount of elo possible to be gained (or lost) for a
          match with K=${eloConsts.match_weight}. The actual score (S) for each
          participant of the match is 1, 0.5 or 0 for a win, draw or loss
          respectively. The expected score (E) for each participant is
          calculated as:`}
          <div className="formula">
            <img src={expectedOddsPng} />
            <img src={expectedOddsQPng} />
          </div>
          {`This is done for each match sequentially to calculate every participant's elo to 
            allow for future comparison. For two participants with equal elo before the match, their expected 
            outcomes will both be 0.5 leading to a ${eloConsts.match_weight /
              2} point increase for the winner and ${eloConsts.match_weight /
            2} point loss for the loser.`}
        </div>
      </React.Fragment>
      <React.Fragment>
        <h3>Multiple Competitor Matches</h3>
        <div className="plain-text">
          We can generalise the expected score for matches amongst more than 2
          singles competitors e.g. triple threat and fatal 4-way:
          <div className="formula">
            <img src={multiPersonOddsPng} />
          </div>
          {`With this we maintain \\sum E = 1 and the total points gained will still be equal 
            to the points lost for each match. For a fatal 4-way between 4 competitors of equal elo they will 
            each have an expected score of 0.25. The winner will obtain ${eloConsts.match_weight *
              0.75} points and each loser will lose ${eloConsts.match_weight *
            0.25}.`}
        </div>
      </React.Fragment>
      <React.Fragment>
        <h3>Tag Team and Handicap Matches</h3>
        <div className="plain-text">
          {`For tag team and handicap matches we treat each team as a
          single competitor when calculating the expected score for that team.
          This is done by summing the total Q-value for each team and
          distributing the points gained/lost amongts the members of that team. The updated formula looks as follows:`}
          <div className="formula">
            <img src={tagTeamOddsPng} />
          </div>
          {`where \\sum Q_{team} and \\sum Q_{all} are the sums of the Q values for the 
            particular participant's team and all participants of the match respectively and N_{team} is the 
            number of people in the particular participant's team. For a 2v2 tag team match with all competitors of 
            equal elo the winners will each obtain 8 points with the losers each losing 8 also.`}
          <br />
          <br />
          {`For a 1v2 handicap match where all competitors have an equal elo we have an expected score 
              of 0.2 and 0.8 for the single competitor and the team of 2 respectively. If the single competitor 
              is to win they will obtain 25.6 points and each of the losing team will lose 12.8 points. If the 
              single competitor loses then it will instead be a loss of 6.4 points for them and a gain of 3.2 
              points each for the victors.`}
        </div>
      </React.Fragment>
    </div>
  );
};

export default Faq;
