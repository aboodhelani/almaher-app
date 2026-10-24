// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(version) => "Version ${version}";

  static String m1(count) => "${count} ayahs";

  static String m2(name) => "Pages in “${name}” move to General.";

  static String m3(page) => "Save page ${page} in";

  static String m4(page) => "Continue reading · page ${page}";

  static String m5(name) => "Delete ${name}?";

  static String m6(count) => "${count} surahs downloaded";

  static String m7(opening, surah, ayah) =>
      "Due next: ${opening}… (${surah} ${ayah})";

  static String m8(count) => "Said so far (${count})";

  static String m9(surah, ayah) => "Opening of ayah ${ayah}, surah ${surah}";

  static String m10(said, total) => "Answer key (${said} of ${total})";

  static String m11(count) => "Total: ${count}";

  static String m12(bid, name) => "Highest bid: ${bid} by ${name}";

  static String m13(max) => "Highest possible bid: ${max}";

  static String m14(n) => "More than ${n}";

  static String m15(n) => "${n} points";

  static String m16(count) => "Your bid: ${count}, waiting for the referee";

  static String m17(name) => "${name} opens the bidding";

  static String m18(bid, points) =>
      "A bid of ${bid} is worth ${points} if you complete it";

  static String m19(bid) =>
      "Your bid is highest: ${bid}, waiting for your opponent";

  static String m20(name) => "${name} quit the match";

  static String m21(wrong, name) => "${wrong} was wrong, ${name} answers now";

  static String m22(name) => "${name} buzzed";

  static String m23(name, count) => "${name} recites now: ${count}";

  static String m24(surah, page, count) => "Page ${page} (${surah}) · ${count}";

  static String m25(name) => "Pass for ${name}";

  static String m26(count) => "${count} pts";

  static String m27(round, rounds, q, qs, n, total) =>
      "Round ${round}/${rounds} · Question ${q}/${qs} · (${n}/${total})";

  static String m28(name, other) =>
      "${name} gave up the question; the points go to ${other}";

  static String m29(current, total) => "Question ${current} of ${total}";

  static String m30(round, rounds, q, qs) =>
      "Round ${round} of ${rounds} · Question ${q} of ${qs}";

  static String m31(value) => "${value}s";

  static String m32(n) => "Start the match (${n} questions)";

  static String m33(name) => "${name}\'s turn";

  static String m34(name) => "Winner: ${name}";

  static String m35(count) => "Worth ${count} points now";

  static String m36(name) => "You are ${name}";

  static String m37(count) => "You recite now: ${count}";

  static String m38(page) => "Saved page ${page}";

  static String m39(page, group) => "Page ${page} saved in “${group}”";

  static String m40(page) => "Removed page ${page} from saved";

  static String m41(name) => "Playing as ${name}";

  static String m42(name) => "vs ${name}";

  static String m43(rate) => "Win rate ${rate}%";

  static String m44(percent) => "Downloading ${percent}";

  static String m45(count, time) =>
      "Get ready: your turn (${count} openings, ${time} each)";

  static String m46(side, page, surah, ayah) =>
      "Answer: ${side} · page ${page} · ${surah} ${ayah}";

  static String m47(n, total) => "${n} of ${total}";

  static String m48(name, right, total) =>
      "${name}: ${right} right of ${total}";

  static String m49(name, n, total) => "${name}\'s turn: ${n} of ${total}";

  static String m50(name) => "Start ${name}\'s turn";

  static String m51(name) => "${name}\'s turn, waiting for the referee";

  static String m52(strikes) =>
      "Answer in turns: ${strikes} mistakes and one pass each";

  static String m53(bid, recite, points) =>
      "A category with a known number of ayahs, shown to both; bids are open and in turn: one player opens (at random on the first question, then alternating) and the other answers.\nEvery bid must beat the last one and restarts the clock (${bid}); bidding the full total ends the bidding.\nA player can say \"go ahead\" and the highest bidder recites; the same happens when time runs out.\nThe bidder names them within ${recite}: completing it scores 1 point under 20, 2 from 20, 3 from 30, and so on; otherwise the opponent scores ${points}.";

  static String m54(time, points) =>
      "An ayah\'s opening is shown: its first word, or two or more while other ayahs start the same way.\nThe player whose turn it is says the opening of the next ayah, then the opponent says the one after it, and so on in turn.\nEach turn has ${time}; a wrong opening or running out of time gives the opponent ${points}.\nIf the surah ends before either makes a mistake, nobody scores.";

  static String m55(time, points) =>
      "The first ayah of a page is shown; each player secretly writes how many ayahs the page has, within ${time}.\nThe exact count wins ${points}, otherwise the closest.\nIf both are exact, the faster one scores; if both wrote the same wrong number, nobody scores.";

  static String m56(time, points) =>
      "The question is hidden from players and audience; the referee reads it aloud.\nThe first to press the buzzer within ${time} answers; a correct answer is worth ${points}.\nIf wrong, the full question is shown to everyone and the opponent answers; if they are wrong too, nobody scores.";

  static String m57(rounds, perRound) =>
      "Two players and a referee; ${rounds} rounds of ${perRound} questions each.\nThe referee prepares the match, choosing its questions or leaving them random, then publishes it so players can enter with its ID.\nPlay in the same room, or remotely with audio and video.";

  static String m58(n) => "${n} points";

  static String m59(count, time, points) =>
      "Each player has a turn: ${count} ayah openings appear one after another, none shared with another ayah.\nWithin ${time}, the player says whether the ayah is on the right page or the left; if time runs out it doesn\'t count.\nPlayers only see their result when their openings are done, then the opponent takes a turn.\nMore right answers wins ${points}; a tie means nobody scores.";

  static String m60(points, strikes, time) =>
      "The first word of an ayah is shown; if other ayahs start the same way, two or more words are shown until it is unique.\nPlayers say the ayah\'s last word aloud; whoever gets it right scores ${points}.\nEach player has ${strikes} tries; after ${time} nobody scores.";

  static String m61(n) => "${n} seconds";

  static String m62(fast, fastPoints, slow, slowPoints, strikes) =>
      "An opening shared by several places is shown; there is no buzzer: either player answers aloud.\nA correct answer within ${fast} is worth ${fastPoints}, within ${slow} ${slowPoints}, after that nobody scores.\nEach player has ${strikes} mistakes; after that they may not answer.";

  static String m63(strikes, cleanPoints, points) =>
      "A question with many answers; players name them in turns.\nNo timer: the referee moves on whenever ready.\nEach player has one pass per question: with no answer, the turn goes to the opponent without a strike.\nEach player has ${strikes} mistakes per question; the last one makes the opponent win: ${cleanPoints} with no mistakes of their own, otherwise ${points}.";

  static String m64(count) => "${count} saved";

  static String m65(n) => "Add (${n})";

  static String m66(n, total) => "${n} of ${total}";

  static String m67(page) => "Page ${page}";

  static String m68(n) => "Total: ${n}";

  static String m69(count) =>
      "No ayah shares ${count} or more consecutive words with it";

  static String m70(count) => "${count} words";

  static String m71(page) => "p. ${page}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About & privacy"),
        "about_subtitle": MessageLookupByLibrary.simpleMessage(
            "Privacy policy and content sources"),
        "about_tagline": MessageLookupByLibrary.simpleMessage(
            "A mushaf for reading and tajweed, and a competition for huffaz"),
        "about_version": m0,
        "app_name": MessageLookupByLibrary.simpleMessage("Al-Maher"),
        "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
        "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "auth_email": MessageLookupByLibrary.simpleMessage("Email"),
        "auth_err_email_taken": MessageLookupByLibrary.simpleMessage(
            "This email is registered — sign in"),
        "auth_err_generic": MessageLookupByLibrary.simpleMessage(
            "Something went wrong, try again"),
        "auth_err_invalid_credentials":
            MessageLookupByLibrary.simpleMessage("Wrong email or password"),
        "auth_err_invalid_email":
            MessageLookupByLibrary.simpleMessage("Invalid email"),
        "auth_err_name": MessageLookupByLibrary.simpleMessage(
            "Enter a name of at least 2 letters"),
        "auth_err_weak_password": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters"),
        "auth_gate_subtitle": MessageLookupByLibrary.simpleMessage(
            "Sign in or create an account to play and keep your results. Reading is open to everyone."),
        "auth_gate_title": MessageLookupByLibrary.simpleMessage(
            "The competition needs an account"),
        "auth_login": MessageLookupByLibrary.simpleMessage("Sign in"),
        "auth_login_title": MessageLookupByLibrary.simpleMessage("Sign in"),
        "auth_name":
            MessageLookupByLibrary.simpleMessage("Name shown to opponents"),
        "auth_password": MessageLookupByLibrary.simpleMessage("Password"),
        "auth_register": MessageLookupByLibrary.simpleMessage("Create account"),
        "auth_register_title":
            MessageLookupByLibrary.simpleMessage("New account"),
        "auth_to_login":
            MessageLookupByLibrary.simpleMessage("Have an account? Sign in"),
        "auth_to_register":
            MessageLookupByLibrary.simpleMessage("No account? Create one"),
        "ayah_label": MessageLookupByLibrary.simpleMessage("Ayah"),
        "ayahs_count": m1,
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "dark_mode": MessageLookupByLibrary.simpleMessage("Dark mode"),
        "dark_mode_subtitle": MessageLookupByLibrary.simpleMessage(
            "Black background, white text"),
        "delete_account":
            MessageLookupByLibrary.simpleMessage("Delete account"),
        "delete_account_body": MessageLookupByLibrary.simpleMessage(
            "Your account will be deleted permanently. Your past matches stay in the history without your name. Enter your password to confirm."),
        "delete_account_confirm":
            MessageLookupByLibrary.simpleMessage("Delete permanently"),
        "delete_account_done":
            MessageLookupByLibrary.simpleMessage("Your account was deleted"),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "failed_to_load_quran":
            MessageLookupByLibrary.simpleMessage("Could not load the Quran"),
        "font_amiri": MessageLookupByLibrary.simpleMessage("Amiri Quran"),
        "font_hafs":
            MessageLookupByLibrary.simpleMessage("Hafs (King Fahd Complex)"),
        "font_hafs_note":
            MessageLookupByLibrary.simpleMessage("As in the printed mushaf"),
        "font_noto": MessageLookupByLibrary.simpleMessage("Noto Naskh"),
        "game_sounds":
            MessageLookupByLibrary.simpleMessage("Competition sounds"),
        "game_sounds_subtitle": MessageLookupByLibrary.simpleMessage(
            "Buzzer, right and wrong answers, last seconds"),
        "group_create": MessageLookupByLibrary.simpleMessage("Create"),
        "group_create_save":
            MessageLookupByLibrary.simpleMessage("Create and save"),
        "group_default": MessageLookupByLibrary.simpleMessage("General"),
        "group_default_note": MessageLookupByLibrary.simpleMessage("No group"),
        "group_delete": MessageLookupByLibrary.simpleMessage("Delete group"),
        "group_delete_body": m2,
        "group_empty":
            MessageLookupByLibrary.simpleMessage("No pages in this group yet"),
        "group_name": MessageLookupByLibrary.simpleMessage("Group name"),
        "group_name_hint":
            MessageLookupByLibrary.simpleMessage("e.g. Tahajjud khatmah"),
        "group_new": MessageLookupByLibrary.simpleMessage("New group"),
        "group_save_title": m3,
        "home_continue": m4,
        "home_greeting":
            MessageLookupByLibrary.simpleMessage("Assalamu alaikum"),
        "home_more": MessageLookupByLibrary.simpleMessage("More"),
        "home_play": MessageLookupByLibrary.simpleMessage("Competition"),
        "home_play_now": MessageLookupByLibrary.simpleMessage("Play now"),
        "home_play_subtitle": MessageLookupByLibrary.simpleMessage(
            "Challenge another hafiz, with a referee"),
        "home_read": MessageLookupByLibrary.simpleMessage("Read the Quran"),
        "home_read_subtitle": MessageLookupByLibrary.simpleMessage(
            "Mushaf with tajweed, similar ayahs and search"),
        "home_rounds":
            MessageLookupByLibrary.simpleMessage("Eight rounds · 32 questions"),
        "home_settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "home_start_reading":
            MessageLookupByLibrary.simpleMessage("Start reading"),
        "home_tajweed_guide":
            MessageLookupByLibrary.simpleMessage("Tajweed guide"),
        "juz": MessageLookupByLibrary.simpleMessage("Juz"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "leaderboard": MessageLookupByLibrary.simpleMessage("Leaderboard"),
        "leaderboard_empty": MessageLookupByLibrary.simpleMessage(
            "No results yet — be the first"),
        "library": MessageLookupByLibrary.simpleMessage("Tafsir & recitations"),
        "library_bundled": MessageLookupByLibrary.simpleMessage("Built in"),
        "library_delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "library_delete_confirm": m5,
        "library_download": MessageLookupByLibrary.simpleMessage("Download"),
        "library_download_all":
            MessageLookupByLibrary.simpleMessage("Download all"),
        "library_download_failed":
            MessageLookupByLibrary.simpleMessage("Download failed. Try again."),
        "library_downloaded":
            MessageLookupByLibrary.simpleMessage("Downloaded"),
        "library_in_use": MessageLookupByLibrary.simpleMessage("In use"),
        "library_offline": MessageLookupByLibrary.simpleMessage(
            "Couldn\'t load the list. Check your internet connection."),
        "library_reciters": MessageLookupByLibrary.simpleMessage("Reciters"),
        "library_search":
            MessageLookupByLibrary.simpleMessage("Search by name or language"),
        "library_subtitle": MessageLookupByLibrary.simpleMessage(
            "Download a tafsir, translation or reciter to use offline"),
        "library_surahs_count": m6,
        "library_tafsirs": MessageLookupByLibrary.simpleMessage("Tafsirs"),
        "library_translations":
            MessageLookupByLibrary.simpleMessage("Translations"),
        "library_use": MessageLookupByLibrary.simpleMessage("Use"),
        "light_mode": MessageLookupByLibrary.simpleMessage("Light mode"),
        "lobby_subtitle": MessageLookupByLibrary.simpleMessage(
            "Pick your role and start the match"),
        "lobby_title":
            MessageLookupByLibrary.simpleMessage("Ready for the challenge?"),
        "logout": MessageLookupByLibrary.simpleMessage("Sign out"),
        "match_aba_next": m7,
        "match_aba_said": m8,
        "match_aba_source": m9,
        "match_aba_your_turn": MessageLookupByLibrary.simpleMessage(
            "Your turn: say the next ayah\'s opening"),
        "match_adjust_scores":
            MessageLookupByLibrary.simpleMessage("Adjust scores"),
        "match_answer_key": m10,
        "match_answer_label": MessageLookupByLibrary.simpleMessage("Answer"),
        "match_answered": MessageLookupByLibrary.simpleMessage("Answered"),
        "match_answered_first": MessageLookupByLibrary.simpleMessage("First"),
        "match_answering_now":
            MessageLookupByLibrary.simpleMessage("Answering"),
        "match_auction_total": m11,
        "match_ayah_number_prompt": MessageLookupByLibrary.simpleMessage(
            "What is this ayah\'s number in its surah?"),
        "match_bid_high": m12,
        "match_bid_hint": MessageLookupByLibrary.simpleMessage(
            "Each bid restarts the one-minute clock; when it runs out the highest bidder recites"),
        "match_bid_max": m13,
        "match_bid_more_than": m14,
        "match_bid_none": MessageLookupByLibrary.simpleMessage(
            "No bids yet: open the bidding"),
        "match_bid_pass":
            MessageLookupByLibrary.simpleMessage("Go ahead, you recite"),
        "match_bid_points": m15,
        "match_bid_points1": MessageLookupByLibrary.simpleMessage("1 point"),
        "match_bid_points2": MessageLookupByLibrary.simpleMessage("2 points"),
        "match_bid_raise": MessageLookupByLibrary.simpleMessage("Bid"),
        "match_bid_sent": m16,
        "match_bid_wait_open": m17,
        "match_bid_worth": m18,
        "match_bid_you_high": m19,
        "match_bid_your_open":
            MessageLookupByLibrary.simpleMessage("You open the bidding"),
        "match_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "match_close_bids":
            MessageLookupByLibrary.simpleMessage("Close bidding"),
        "match_code": MessageLookupByLibrary.simpleMessage("Match code"),
        "match_code_copied":
            MessageLookupByLibrary.simpleMessage("Match code copied"),
        "match_correct": MessageLookupByLibrary.simpleMessage("Correct"),
        "match_create": MessageLookupByLibrary.simpleMessage("Create match"),
        "match_draw": MessageLookupByLibrary.simpleMessage("Draw"),
        "match_end_body": MessageLookupByLibrary.simpleMessage(
            "The match ends now; the current scores decide the winner."),
        "match_end_do": MessageLookupByLibrary.simpleMessage("End match"),
        "match_end_now":
            MessageLookupByLibrary.simpleMessage("End the match now"),
        "match_end_title":
            MessageLookupByLibrary.simpleMessage("End the match?"),
        "match_enter_by_id":
            MessageLookupByLibrary.simpleMessage("Enter match"),
        "match_err_already_answered":
            MessageLookupByLibrary.simpleMessage("You already answered"),
        "match_err_already_finished":
            MessageLookupByLibrary.simpleMessage("The match has already ended"),
        "match_err_already_player": MessageLookupByLibrary.simpleMessage(
            "You\'re a player in this match"),
        "match_err_already_referee": MessageLookupByLibrary.simpleMessage(
            "You\'re the referee in this match"),
        "match_err_closed": MessageLookupByLibrary.simpleMessage(
            "Your previous match has ended or was closed"),
        "match_err_code_taken": MessageLookupByLibrary.simpleMessage(
            "This ID is used by a live match"),
        "match_err_full": MessageLookupByLibrary.simpleMessage(
            "This match already has two players"),
        "match_err_generic": MessageLookupByLibrary.simpleMessage(
            "Something went wrong, try again"),
        "match_err_invalid_answer":
            MessageLookupByLibrary.simpleMessage("Invalid number"),
        "match_err_invalid_code": MessageLookupByLibrary.simpleMessage(
            "Match ID: 3–20 letters or digits, no spaces"),
        "match_err_login_required":
            MessageLookupByLibrary.simpleMessage("Sign in to play"),
        "match_err_name":
            MessageLookupByLibrary.simpleMessage("Enter your name"),
        "match_err_no_rounds":
            MessageLookupByLibrary.simpleMessage("Pick at least one round"),
        "match_err_not_found":
            MessageLookupByLibrary.simpleMessage("No match with this code"),
        "match_err_not_published": MessageLookupByLibrary.simpleMessage(
            "The referee hasn\'t published this match yet"),
        "match_err_players_missing": MessageLookupByLibrary.simpleMessage(
            "Both players have not joined yet"),
        "match_err_role_taken":
            MessageLookupByLibrary.simpleMessage("This role is taken"),
        "match_err_time_up": MessageLookupByLibrary.simpleMessage("Time is up"),
        "match_err_too_many":
            MessageLookupByLibrary.simpleMessage("Too many questions"),
        "match_err_unreachable":
            MessageLookupByLibrary.simpleMessage("Could not reach the server"),
        "match_final_score":
            MessageLookupByLibrary.simpleMessage("Final score"),
        "match_find": MessageLookupByLibrary.simpleMessage("Find me a match"),
        "match_finish": MessageLookupByLibrary.simpleMessage("Finish match"),
        "match_forfeit_match":
            MessageLookupByLibrary.simpleMessage("Quit match"),
        "match_forfeit_match_body": MessageLookupByLibrary.simpleMessage(
            "You lose the match and your opponent wins, whatever the score."),
        "match_forfeit_match_do":
            MessageLookupByLibrary.simpleMessage("Quit match"),
        "match_forfeit_match_title":
            MessageLookupByLibrary.simpleMessage("Quit the match?"),
        "match_forfeit_question":
            MessageLookupByLibrary.simpleMessage("Skip question"),
        "match_forfeit_question_body": MessageLookupByLibrary.simpleMessage(
            "The question ends now and its points go to your opponent."),
        "match_forfeit_question_do":
            MessageLookupByLibrary.simpleMessage("Give up"),
        "match_forfeit_question_title":
            MessageLookupByLibrary.simpleMessage("Give up this question?"),
        "match_forfeited": m20,
        "match_got_point": MessageLookupByLibrary.simpleMessage("Point"),
        "match_handed_over": m21,
        "match_id_hint_empty": MessageLookupByLibrary.simpleMessage(
            "Leave empty and the server will find you an open match"),
        "match_id_hint_set": MessageLookupByLibrary.simpleMessage(
            "You\'ll enter exactly this match; it\'s created with this ID if it doesn\'t exist"),
        "match_id_optional":
            MessageLookupByLibrary.simpleMessage("Match ID (optional)"),
        "match_id_placeholder":
            MessageLookupByLibrary.simpleMessage("Match ID"),
        "match_join": MessageLookupByLibrary.simpleMessage("Join match"),
        "match_leave": MessageLookupByLibrary.simpleMessage("Leave"),
        "match_listen_hint": MessageLookupByLibrary.simpleMessage(
            "The question appears once it\'s decided"),
        "match_listen_question":
            MessageLookupByLibrary.simpleMessage("Listen to the referee"),
        "match_locked_out": MessageLookupByLibrary.simpleMessage(
            "Wrong — the other player\'s chance"),
        "match_manual_point":
            MessageLookupByLibrary.simpleMessage("End question by hand"),
        "match_mode": MessageLookupByLibrary.simpleMessage("How you play"),
        "match_mode_remote": MessageLookupByLibrary.simpleMessage("Remote"),
        "match_mode_remote_desc":
            MessageLookupByLibrary.simpleMessage("Each from their own device"),
        "match_mode_same_room":
            MessageLookupByLibrary.simpleMessage("Same room"),
        "match_mode_same_room_desc":
            MessageLookupByLibrary.simpleMessage("Everyone in one place"),
        "match_name_hint":
            MessageLookupByLibrary.simpleMessage("e.g. Abdullah"),
        "match_new": MessageLookupByLibrary.simpleMessage("New match"),
        "match_next": MessageLookupByLibrary.simpleMessage("Next question"),
        "match_no_point": MessageLookupByLibrary.simpleMessage("No point"),
        "match_no_timer": MessageLookupByLibrary.simpleMessage("No timer"),
        "match_other_buzzed": m22,
        "match_other_recites": m23,
        "match_page_answer": m24,
        "match_pass_for": m25,
        "match_pass_turn": MessageLookupByLibrary.simpleMessage("Pass (once)"),
        "match_passed": MessageLookupByLibrary.simpleMessage("Passed"),
        "match_players_ready":
            MessageLookupByLibrary.simpleMessage("Both players are ready"),
        "match_points_chip": m26,
        "match_press_buzzer":
            MessageLookupByLibrary.simpleMessage("Press the buzzer to answer"),
        "match_progress": m27,
        "match_question_done": MessageLookupByLibrary.simpleMessage("Done"),
        "match_question_forfeited": m28,
        "match_question_of": m29,
        "match_recite_fail": MessageLookupByLibrary.simpleMessage("Failed"),
        "match_recite_ok": MessageLookupByLibrary.simpleMessage("Succeeded"),
        "match_remote_media_soon": MessageLookupByLibrary.simpleMessage(
            "Live audio/video between players comes in the next step"),
        "match_replace":
            MessageLookupByLibrary.simpleMessage("Alternative question"),
        "match_replace_body": MessageLookupByLibrary.simpleMessage(
            "This question will be replaced by another from the same round, marked as an alternative for the players. Any points it gave are taken back."),
        "match_replace_do": MessageLookupByLibrary.simpleMessage("Swap"),
        "match_replace_title":
            MessageLookupByLibrary.simpleMessage("Swap the question?"),
        "match_replaced_chip":
            MessageLookupByLibrary.simpleMessage("Alternative"),
        "match_reveal": MessageLookupByLibrary.simpleMessage("Reveal answers"),
        "match_role_player": MessageLookupByLibrary.simpleMessage("Player"),
        "match_role_player1": MessageLookupByLibrary.simpleMessage("Player 1"),
        "match_role_player2": MessageLookupByLibrary.simpleMessage("Player 2"),
        "match_role_player_desc": MessageLookupByLibrary.simpleMessage(
            "Answer and compete for points"),
        "match_role_referee": MessageLookupByLibrary.simpleMessage("Referee"),
        "match_role_referee_desc":
            MessageLookupByLibrary.simpleMessage("Run the questions and judge"),
        "match_round_ayah_number":
            MessageLookupByLibrary.simpleMessage("Ayah Number"),
        "match_round_of": m30,
        "match_sard_out":
            MessageLookupByLibrary.simpleMessage("You used your tries"),
        "match_sard_speak": MessageLookupByLibrary.simpleMessage(
            "No buzzer: say the ayah\'s last word aloud"),
        "match_seats": MessageLookupByLibrary.simpleMessage("Seats"),
        "match_seconds": m31,
        "match_send": MessageLookupByLibrary.simpleMessage("Send"),
        "match_share_code": MessageLookupByLibrary.simpleMessage(
            "Share the code so others join this match"),
        "match_similar_out":
            MessageLookupByLibrary.simpleMessage("You used your three tries"),
        "match_similar_referee":
            MessageLookupByLibrary.simpleMessage("Judge whoever answered"),
        "match_similar_speak": MessageLookupByLibrary.simpleMessage(
            "No buzzer: answer aloud right away"),
        "match_start": m32,
        "match_start_ayah_number":
            MessageLookupByLibrary.simpleMessage("Start the Ayah Number round"),
        "match_strike": MessageLookupByLibrary.simpleMessage("Strike"),
        "match_tap_to_copy":
            MessageLookupByLibrary.simpleMessage("Tap to copy"),
        "match_tiebreak_chip": MessageLookupByLibrary.simpleMessage("Decider"),
        "match_turn_of": m33,
        "match_vs": MessageLookupByLibrary.simpleMessage("VS"),
        "match_wait_referee_next": MessageLookupByLibrary.simpleMessage(
            "Waiting for the referee\'s next question"),
        "match_wait_referee_start": MessageLookupByLibrary.simpleMessage(
            "Waiting for the referee to start"),
        "match_wait_reveal": MessageLookupByLibrary.simpleMessage(
            "Sent, waiting for the reveal"),
        "match_waiting_answer": MessageLookupByLibrary.simpleMessage("…"),
        "match_waiting_buzz":
            MessageLookupByLibrary.simpleMessage("Waiting for a buzz"),
        "match_waiting_players": MessageLookupByLibrary.simpleMessage(
            "Waiting for both players to join with the code"),
        "match_waiting_seat":
            MessageLookupByLibrary.simpleMessage("Waiting to join"),
        "match_winner": m34,
        "match_winner_chip": MessageLookupByLibrary.simpleMessage("Winner"),
        "match_worth": m35,
        "match_wrong": MessageLookupByLibrary.simpleMessage("Wrong"),
        "match_you_are": m36,
        "match_you_buzzed": MessageLookupByLibrary.simpleMessage("Answer now!"),
        "match_you_recite": m37,
        "match_you_short": MessageLookupByLibrary.simpleMessage("You"),
        "match_your_answer":
            MessageLookupByLibrary.simpleMessage("Ayah number"),
        "match_your_bid": MessageLookupByLibrary.simpleMessage("Your bid"),
        "match_your_chance": MessageLookupByLibrary.simpleMessage(
            "Your opponent was wrong — answer now"),
        "match_your_name": MessageLookupByLibrary.simpleMessage("Your name"),
        "match_your_role": MessageLookupByLibrary.simpleMessage("Your role"),
        "match_your_turn": MessageLookupByLibrary.simpleMessage("Your turn"),
        "meccan": MessageLookupByLibrary.simpleMessage("Meccan"),
        "media_camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "media_connecting":
            MessageLookupByLibrary.simpleMessage("Connecting audio and video…"),
        "media_failed": MessageLookupByLibrary.simpleMessage(
            "Couldn\'t connect audio and video"),
        "media_mic": MessageLookupByLibrary.simpleMessage("Microphone"),
        "media_not_here": MessageLookupByLibrary.simpleMessage("Not here yet"),
        "media_retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "medinan": MessageLookupByLibrary.simpleMessage("Medinan"),
        "more_downloads": MessageLookupByLibrary.simpleMessage("More…"),
        "page": MessageLookupByLibrary.simpleMessage("Page"),
        "page_saved": m38,
        "page_saved_in": m39,
        "page_unsaved": m40,
        "playing_as": m41,
        "privacy_account_body": MessageLookupByLibrary.simpleMessage(
            "To play we keep your email, your name, your password (hashed) and your match results, for your stats and the leaderboard. We never sell or share your data."),
        "privacy_account_title":
            MessageLookupByLibrary.simpleMessage("Competition account"),
        "privacy_delete_body": MessageLookupByLibrary.simpleMessage(
            "You can delete your account at any time from your profile. Your email, name and password are removed; match results stay without your name."),
        "privacy_delete_title":
            MessageLookupByLibrary.simpleMessage("Deleting your data"),
        "privacy_media_body": MessageLookupByLibrary.simpleMessage(
            "In remote matches your microphone and camera stream live to the other participants only when you turn them on. Nothing is recorded or stored."),
        "privacy_media_title":
            MessageLookupByLibrary.simpleMessage("Audio and video"),
        "privacy_reading_body": MessageLookupByLibrary.simpleMessage(
            "The mushaf, search, tajweed, tafsirs and recitations work without signing up. Saved pages, your last page and your downloads stay on your device only."),
        "privacy_reading_title":
            MessageLookupByLibrary.simpleMessage("Reading needs no account"),
        "privacy_title": MessageLookupByLibrary.simpleMessage("Privacy policy"),
        "profile_draws": MessageLookupByLibrary.simpleMessage("Draws"),
        "profile_losses": MessageLookupByLibrary.simpleMessage("Losses"),
        "profile_matches": MessageLookupByLibrary.simpleMessage("Matches"),
        "profile_no_matches":
            MessageLookupByLibrary.simpleMessage("No matches yet"),
        "profile_points": MessageLookupByLibrary.simpleMessage("Points"),
        "profile_recent":
            MessageLookupByLibrary.simpleMessage("Recent matches"),
        "profile_title": MessageLookupByLibrary.simpleMessage("My account"),
        "profile_vs": m42,
        "profile_win_rate": m43,
        "profile_wins": MessageLookupByLibrary.simpleMessage("Wins"),
        "quran": MessageLookupByLibrary.simpleMessage("The Holy Quran"),
        "quran_font": MessageLookupByLibrary.simpleMessage("Mushaf font"),
        "reader_more": MessageLookupByLibrary.simpleMessage("More"),
        "recitation": MessageLookupByLibrary.simpleMessage("Listen"),
        "recitation_download_surah": MessageLookupByLibrary.simpleMessage(
            "Download the surah to listen"),
        "recitation_downloading": m44,
        "recitation_play_from":
            MessageLookupByLibrary.simpleMessage("Listen from this ayah"),
        "recitation_reciter": MessageLookupByLibrary.simpleMessage("Reciter"),
        "referee_auction": MessageLookupByLibrary.simpleMessage(
            "Announce the category and follow the bids; you can end them with Close bidding. Then tap Correct if the player completes the bid, or Wrong."),
        "referee_ayah_by_ayah": MessageLookupByLibrary.simpleMessage(
            "Read the ayah\'s opening. You see the ayah due next: tap Correct if the player whose turn it is says its opening (the turn passes to the opponent), or Wrong to give the opponent the point."),
        "referee_ayah_number": MessageLookupByLibrary.simpleMessage(
            "Read the ayah aloud; once both have written their count, tap Reveal answers."),
        "referee_buzzer": MessageLookupByLibrary.simpleMessage(
            "Read the question clearly (only you can see it), then judge whoever buzzed first with Correct or Wrong."),
        "referee_right_left": MessageLookupByLibrary.simpleMessage(
            "Tap Start turn for each player when they\'re ready; answers are scored from their phone, and you see each opening\'s correct side."),
        "referee_sard": MessageLookupByLibrary.simpleMessage(
            "Read the ayah\'s opening; when one of them answers, tap Correct or Wrong under their name."),
        "referee_similar": MessageLookupByLibrary.simpleMessage(
            "Read the opening; when one of them answers, tap Correct or Wrong under their name."),
        "referee_tools": MessageLookupByLibrary.simpleMessage("Referee tools"),
        "referee_tools_hint": MessageLookupByLibrary.simpleMessage(
            "Manual point and score fixes"),
        "referee_what_do_you_know": MessageLookupByLibrary.simpleMessage(
            "Read the question; tap Correct for each right answer or Wrong for a mistake, and the turn passes automatically. If the player asks to pass, tap Pass (once per player). Move on when you see fit."),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "rl_get_ready": m45,
        "rl_key": m46,
        "rl_left": MessageLookupByLibrary.simpleMessage("Left"),
        "rl_progress": m47,
        "rl_result": m48,
        "rl_right": MessageLookupByLibrary.simpleMessage("Right"),
        "rl_running_other": m49,
        "rl_start_run": m50,
        "rl_waiting_run": m51,
        "round_auction": MessageLookupByLibrary.simpleMessage("Auction"),
        "round_ayah_by_ayah":
            MessageLookupByLibrary.simpleMessage("Ayah by ayah"),
        "round_ayah_number": MessageLookupByLibrary.simpleMessage("Ayah count"),
        "round_buzzer": MessageLookupByLibrary.simpleMessage("Buzzer"),
        "round_hint_auction": MessageLookupByLibrary.simpleMessage(
            "Bid openly on how many you can name; the highest bidder recites"),
        "round_hint_ayah_by_ayah": MessageLookupByLibrary.simpleMessage(
            "On your turn, say the next ayah\'s opening"),
        "round_hint_ayah_number": MessageLookupByLibrary.simpleMessage(
            "This is the first ayah of a page: how many ayahs are on it?"),
        "round_hint_buzzer":
            MessageLookupByLibrary.simpleMessage("First to buzz answers"),
        "round_hint_right_left": MessageLookupByLibrary.simpleMessage(
            "Is this ayah on the right page or the left?"),
        "round_hint_sard":
            MessageLookupByLibrary.simpleMessage("Say this ayah\'s last word"),
        "round_hint_similar": MessageLookupByLibrary.simpleMessage(
            "Answer aloud if you know the shared phrase"),
        "round_hint_what_do_you_know": m52,
        "round_right_left":
            MessageLookupByLibrary.simpleMessage("Right or left"),
        "round_sard": MessageLookupByLibrary.simpleMessage("Ayah ending"),
        "round_similar": MessageLookupByLibrary.simpleMessage("Similar ayahs"),
        "round_what_do_you_know":
            MessageLookupByLibrary.simpleMessage("What do you know"),
        "rules_auction": m53,
        "rules_ayah_by_ayah": m54,
        "rules_ayah_number": m55,
        "rules_buzzer": m56,
        "rules_minute": MessageLookupByLibrary.simpleMessage("a minute"),
        "rules_overview": m57,
        "rules_overview_tiebreak": MessageLookupByLibrary.simpleMessage(
            "No draws: if the scores are level at the end, decider questions from the last round are played until one leads."),
        "rules_overview_title":
            MessageLookupByLibrary.simpleMessage("The match"),
        "rules_players": MessageLookupByLibrary.simpleMessage("For players"),
        "rules_point1": MessageLookupByLibrary.simpleMessage("1 point"),
        "rules_point2": MessageLookupByLibrary.simpleMessage("2 points"),
        "rules_points": m58,
        "rules_referee": MessageLookupByLibrary.simpleMessage("Referee"),
        "rules_referee_general": MessageLookupByLibrary.simpleMessage(
            "You can always tap Alternative question to swap it; players see it is an alternative, and points already given for it are taken back.\nYou can always tap Next question; if it wasn\'t decided, nobody scores.\nYou start the match once both players are in."),
        "rules_referee_general_title": MessageLookupByLibrary.simpleMessage(
            "For the referee, every round"),
        "rules_right_left": m59,
        "rules_sard": m60,
        "rules_secs": m61,
        "rules_similar": m62,
        "rules_title": MessageLookupByLibrary.simpleMessage("How to play"),
        "rules_what_do_you_know": m63,
        "save_page": MessageLookupByLibrary.simpleMessage("Save page"),
        "saved_count": m64,
        "saved_pages": MessageLookupByLibrary.simpleMessage("Saved pages"),
        "saved_pages_empty":
            MessageLookupByLibrary.simpleMessage("No saved pages yet"),
        "saved_pages_empty_hint": MessageLookupByLibrary.simpleMessage(
            "Tap the save button above a mushaf page to come back to it later"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "search_all_surahs": MessageLookupByLibrary.simpleMessage("All surahs"),
        "search_ayah": MessageLookupByLibrary.simpleMessage("Ayah"),
        "search_failed": MessageLookupByLibrary.simpleMessage("Search failed"),
        "search_full_match": MessageLookupByLibrary.simpleMessage("Full match"),
        "search_hint":
            MessageLookupByLibrary.simpleMessage("Search a surah or ayah"),
        "search_in_surah_hint":
            MessageLookupByLibrary.simpleMessage("Ayah number or words"),
        "search_in_surah_start_hint": MessageLookupByLibrary.simpleMessage(
            "Type an ayah number to go to it,\nor words to search inside this surah."),
        "search_no_results": MessageLookupByLibrary.simpleMessage("No results"),
        "search_partial_match":
            MessageLookupByLibrary.simpleMessage("Partial match"),
        "search_start_hint": MessageLookupByLibrary.simpleMessage(
            "Type a surah name or words from an ayah.\nAdd tashkeel to see full matches."),
        "search_surahs": MessageLookupByLibrary.simpleMessage("Surahs"),
        "search_tashkeel_keyboard":
            MessageLookupByLibrary.simpleMessage("Tashkeel keyboard"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "settings_competition":
            MessageLookupByLibrary.simpleMessage("Competition"),
        "settings_reading":
            MessageLookupByLibrary.simpleMessage("Reading & listening"),
        "setup_add": MessageLookupByLibrary.simpleMessage("Add"),
        "setup_add_selected": m65,
        "setup_answer": MessageLookupByLibrary.simpleMessage("Answer"),
        "setup_bank_empty": MessageLookupByLibrary.simpleMessage(
            "No saved questions for this round. Try Generate."),
        "setup_count": m66,
        "setup_count_save": MessageLookupByLibrary.simpleMessage("Save"),
        "setup_draft_note": MessageLookupByLibrary.simpleMessage(
            "Not published yet: players can\'t enter until you publish. Choose each round\'s questions, or leave them to be picked at random."),
        "setup_from_bank":
            MessageLookupByLibrary.simpleMessage("From the bank"),
        "setup_full":
            MessageLookupByLibrary.simpleMessage("This round is full"),
        "setup_generate": MessageLookupByLibrary.simpleMessage("Generate"),
        "setup_new": MessageLookupByLibrary.simpleMessage("New question"),
        "setup_page":
            MessageLookupByLibrary.simpleMessage("Page number (1–604)"),
        "setup_page_label": m67,
        "setup_prompt": MessageLookupByLibrary.simpleMessage("Question"),
        "setup_publish":
            MessageLookupByLibrary.simpleMessage("Publish the match"),
        "setup_publish_hint": MessageLookupByLibrary.simpleMessage(
            "Once published, players can enter with the match ID"),
        "setup_random_rest":
            MessageLookupByLibrary.simpleMessage("The rest at random"),
        "setup_refs": MessageLookupByLibrary.simpleMessage(
            "Ayahs (surah:ayah, comma separated)"),
        "setup_rl_ayahs": MessageLookupByLibrary.simpleMessage(
            "Ayahs (an even number, usually 12)"),
        "setup_rounds_hint": MessageLookupByLibrary.simpleMessage(
            "Pick at least one round and how many questions each (4 per round by default)."),
        "setup_rounds_title":
            MessageLookupByLibrary.simpleMessage("Rounds and question counts"),
        "setup_rounds_total": m68,
        "setup_sard_ayah":
            MessageLookupByLibrary.simpleMessage("Ayah (surah:ayah)"),
        "setup_title":
            MessageLookupByLibrary.simpleMessage("Prepare the match"),
        "sheet_tab_similar":
            MessageLookupByLibrary.simpleMessage("Similar & tajweed"),
        "sheet_tab_tafsir":
            MessageLookupByLibrary.simpleMessage("Tafsir & translation"),
        "similar_ayahs": MessageLookupByLibrary.simpleMessage("Similar ayahs"),
        "similar_colors":
            MessageLookupByLibrary.simpleMessage("Colour similar ayahs"),
        "similar_colors_subtitle": MessageLookupByLibrary.simpleMessage(
            "Mark repeated ayahs and phrases shared between ayahs"),
        "similar_failed": MessageLookupByLibrary.simpleMessage(
            "Could not find similar ayahs"),
        "similar_full": MessageLookupByLibrary.simpleMessage("Full match"),
        "similar_min_words":
            MessageLookupByLibrary.simpleMessage("Minimum shared words"),
        "similar_min_words_subtitle": MessageLookupByLibrary.simpleMessage(
            "Consecutive shared words needed for a partial match"),
        "similar_none": m69,
        "similar_partial":
            MessageLookupByLibrary.simpleMessage("Partial match"),
        "similar_words": m70,
        "sources_body": MessageLookupByLibrary.simpleMessage(
            "Quran text: Tanzil project (tanzil.net), Hafs.\nTafsirs, translations and recitations: alquran.cloud and islamic.network.\nAt-Tafsir Al-Muyassar: King Fahd Complex for the Printing of the Holy Quran.\nFonts: Amiri Quran and IBM Plex Sans Arabic, SIL Open Font License."),
        "sources_title":
            MessageLookupByLibrary.simpleMessage("Content sources"),
        "splash_tagline": MessageLookupByLibrary.simpleMessage(
            "Your companion for reciting and revising the Quran"),
        "surah_filter_hint":
            MessageLookupByLibrary.simpleMessage("Surah name or number"),
        "surah_none":
            MessageLookupByLibrary.simpleMessage("No surah by that name"),
        "surah_page_short": m71,
        "surahs_index": MessageLookupByLibrary.simpleMessage("Surahs"),
        "tafsir": MessageLookupByLibrary.simpleMessage("Tafsir"),
        "tajweed": MessageLookupByLibrary.simpleMessage("Tajweed"),
        "tajweed_colors":
            MessageLookupByLibrary.simpleMessage("Tajweed colours"),
        "tajweed_colors_subtitle": MessageLookupByLibrary.simpleMessage(
            "Colour letters in the mushaf by tajweed rule"),
        "tajweed_details":
            MessageLookupByLibrary.simpleMessage("Tajweed rules"),
        "tajweed_duration": MessageLookupByLibrary.simpleMessage("Length"),
        "tajweed_example": MessageLookupByLibrary.simpleMessage("Example"),
        "tajweed_guide":
            MessageLookupByLibrary.simpleMessage("Tajweed colour guide"),
        "tajweed_guide_subtitle": MessageLookupByLibrary.simpleMessage(
            "What each colour means, its length and an example"),
        "tajweed_letters": MessageLookupByLibrary.simpleMessage("Letters"),
        "tajweed_no_rules": MessageLookupByLibrary.simpleMessage(
            "No coloured rules in this ayah"),
        "tajweed_position": MessageLookupByLibrary.simpleMessage("Where"),
        "tajweed_unavailable": MessageLookupByLibrary.simpleMessage(
            "Could not load tajweed rules"),
        "text_unavailable":
            MessageLookupByLibrary.simpleMessage("Couldn\'t show the text"),
        "translation": MessageLookupByLibrary.simpleMessage("Translation"),
        "undo": MessageLookupByLibrary.simpleMessage("Undo"),
        "you_label": MessageLookupByLibrary.simpleMessage("(you)")
      };
}
