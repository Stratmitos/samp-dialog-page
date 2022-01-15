stock ResetDialogData (playerid) {
    dialogVar[playerid][dialogStaterId] = 0;
    dialogVar[playerid][dialogCurrentPage] = 0;
    dialogVar[playerid][dialogMaxPage] = INVALID_ID;
    format(dialogVar[playerid][dialogLabel], 1280, "");

    for (new j = 0; j < MAX_DATA_PER_DIALOG; j++) {
        dialogData[playerid][FIRST_DATA][j] = 0;
        dialogData[playerid][SECOND_DATA][j] = 0;
    }
}

stock InitiateDialogDataIndex (playerid, fromPage = INVALID_ID) {
    strdel(dialogVar[playerid][dialogLabel], 0, 1279);

    if (fromPage == INVALID_ID) {
        dialogVar[playerid][dialogStaterId] = MAX_DATA_PER_DIALOG * dialogVar[playerid][dialogCurrentPage];
    } else {
        dialogVar[playerid][dialogStaterId] = MAX_DATA_PER_DIALOG * fromPage;
    }

    return dialogVar[playerid][dialogStaterId];
}

stock AddValueToDialog (playerid, index, label[], firstData, secondData = INVALID_ID) {
    dialogData[playerid][FIRST_DATA][index] = firstData;
    dialogData[playerid][SECOND_DATA][index] = secondData;
    strcat(dialogVar[playerid][dialogLabel], label, 1280);

    dialogVar[playerid][dialogStaterId] ++;
}

stock ShowDialogWithPage (playerid, dialogid, caption[], button1[], button2[], dataAmount = INVALID_ID, bool:showPage = false, style = DIALOG_STYLE_TABLIST, bool:showNextPrev = true) {
    if (dataAmount != INVALID_ID) {
        dialogVar[playerid][dialogMaxPage] = dataAmount / MAX_DATA_PER_DIALOG;
    }

    if (showNextPrev) {
        if (IsThisDialogPageLastPage(playerid)) {
            strcat(dialogVar[playerid][dialogLabel], "<~ Previous Page\n", 1280);
        } else if(IsThisDialogPageFirstPage(playerid)) {
            strcat(dialogVar[playerid][dialogLabel], "~> Next Page\n", 1280);
        } else {
            strcat(dialogVar[playerid][dialogLabel], "~> Next Page\n", 1280);
            strcat(dialogVar[playerid][dialogLabel], "<~ Previous Page\n", 1280);
        }
    }

    if (showPage) {
        new captionWithPage[128];
        if (dataAmount != INVALID_ID) {
            format(captionWithPage, 128, "%s | Page: %d/%d", caption, dialogVar[playerid][dialogCurrentPage] + 1, dialogVar[playerid][dialogMaxPage]);
        } else {
            format(captionWithPage, 128, "%s | Page: %d", caption, dialogVar[playerid][dialogCurrentPage] + 1, dialogVar[playerid][dialogMaxPage]);
        }
        ShowPlayerDialog(playerid, dialogid, style, captionWithPage, dialogVar[playerid][dialogLabel], button1, button2);

        return 1;
    }

    ShowPlayerDialog(playerid, dialogid, style, caption, dialogVar[playerid][dialogLabel], button1, button2);

    return 1;
}

stock GetFirstValueDialog (playerid, itemList) {
    return dialogData[playerid][FIRST_DATA][itemList];
}

stock GetSecondValueDialog (playerid, itemList) {
    return dialogData[playerid][SECOND_DATA][itemList];
}

stock InitiateDialogNextPage (playerid) {
    if (IsThisDialogPageLastPage(playerid)) {
        dialogVar[playerid][dialogCurrentPage] --;
    } else {
        dialogVar[playerid][dialogCurrentPage] ++;
    }
}

stock InitiateDialogPreviousPage (playerid) {
    dialogVar[playerid][dialogCurrentPage] --;
}

stock SetThisDialogPageAsLastPage (playerid) {
    dialogVar[playerid][dialogMaxPage] = dialogVar[playerid][dialogCurrentPage];
}

stock IsThisDialogPageFirstPage (playerid) {
    return dialogVar[playerid][dialogCurrentPage] == 0;
}

stock IsThisDialogPageLastPage (playerid) {
    if (dialogVar[playerid][dialogMaxPage] == dialogVar[playerid][dialogCurrentPage] + 1) {
        return 1;
    }

    return 0;
}