import React from "react";
import { Helmet } from "react-helmet";

import eloConsts from "../../../static/elo-consts.json";
import newScorePng from "../../../static/images/formula/new-score.png";
import expectedOddsPng from "../../../static/images/formula/expected-odds.png";
import expectedOddsQPng from "../../../static/images/formula/expected-odds-q.png";
import multiPersonOddsPng from "../../../static/images/formula/multi-person-odds.png";
import multiPersonTeamOddsPng from "../../../static/images/formula/multi-person-team-odds.png";

import "./faq.styl";

const Faq = () => {
  return (
    <React.Fragment>
      <Helmet>
        <title>WWElo - FAQ</title>
        <meta
          name="description"
          content="Answers to freqently asked questions about WWElo"
        />
        <link rel="canonical" href="https://www.wwelo.com/faq" />
      </Helmet>
      <div className="faq">
        <h2>What is Elo?</h2>
        <div className="plain-text">
          <p>
            <a href="https://en.wikipedia.org/wiki/Elo_rating_system">Elo</a> is
            a method for calculating the relative skills of players of a
            particular game, originally chess. Over time each participants Elo
            will change depending on all the previous games they&#8217;ve played
            and who against. Each player&#8217;s Elo can be then used to
            estimate who would win in future games between them.
          </p>
        </div>
        <h2>Calculating Elos</h2>
        <div className="plain-text">
          <p>
            All wrestlers start with an Elo of {eloConsts.default_elo}. After
            each match all participants of the match will get their Elo updated:
            <div className="formula">
              <img src={newScorePng} />
            </div>
            where K is the K-factor and S and E are the actual and expected
            scores of the match for that participant. The K-factor (K), or match
            weight, is the maximum amount of Elo possible to be gained (or lost)
            for a match with K={eloConsts.match_weight}. The actual score (S)
            for each participant of the match is 1, 0.5 or 0 for a win, draw or
            loss respectively. The expected score (E) for each participant is
            calculated as:
            <div className="formula">
              <img src={expectedOddsPng} />
              <img src={expectedOddsQPng} />
            </div>
            This is done for each match sequentially to calculate every
            participant&#8217;s Elo to allow for future comparison. For two
            participants with equal Elo before the match, their expected
            outcomes will both be 0.5 leading to a {eloConsts.match_weight / 2}{" "}
            point increase for the winner and {eloConsts.match_weight / 2} point
            loss for the loser.
          </p>
        </div>
        <h2>Multiple Competitor Matches</h2>
        <div className="plain-text">
          <p>
            We can generalise the expected score for matches amongst more than 2
            singles competitors e.g. triple threat and fatal 4-way:
            <div className="formula">
              <img src={multiPersonOddsPng} />
            </div>
            With this we maintain &#x3a3;E = 1 and the total points gained will
            still be equal to the points lost for each match. For a fatal 4-way
            between 4 competitors of equal Elo they will each have an expected
            score of 0.25. The winner will obtain{" "}
            {eloConsts.match_weight * 0.75} points and each loser will lose{" "}
            {eloConsts.match_weight * 0.25}.
          </p>
        </div>
        <h2>Tag Team and Handicap Matches</h2>
        <div className="plain-text">
          <p>
            For tag team and handicap matches we treat each team as a single
            competitor when calculating the expected score for that team. This
            is done by summing the total Q-value for each team and distributing
            the points gained/lost amongts the members of that team. The updated
            formula looks as follows:
            <div className="formula">
              <img src={multiPersonTeamOddsPng} />
            </div>
            where &#x3a3;NQ<sub>team</sub> and &#x3a3;NQ<sub>all</sub> are the
            sums of the number of members on their team multiplied by the Q
            value for the particular participant&#8217;s team and all
            participants of the match respectively. N<sub>winners</sub> is the
            number of participants who won the match. For a 2v2 tag team match
            with all competitors of equal Elo the winners will each obtain 8
            points with the losers each losing 8 also.
            <br />
            <br />
            For a 1v2 handicap match where all competitors have an equal Elo we
            have an expected score of 0.2 and 0.8 for the single competitor and
            the team of 2 respectively. If the single competitor is to win they
            will obtain 25.6 points and each of the losing team will lose 12.8
            points. If the single competitor loses then it will instead be a
            loss of 6.4 points for them and a gain of 3.2 points each for the
            victors.
          </p>
        </div>
        <h2>Comparing Elos</h2>
        <div className="plain-text">
          <p>
            Due to how Elo is calculated we cannot easily compare Elos of
            wrestlers easily across brands, eras and genders. This is due to the
            fact that these wrestlers will have faced a different pool of
            wrestlers to get to their current rating. This should be taken in to
            account in such comparisons as Bruno Sammartino and John Cena.
          </p>
        </div>
      </div>
    </React.Fragment>
  );
};

export default Faq;
