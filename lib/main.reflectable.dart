// This file has been generated by the reflectable package.
// https://github.com/dart-lang/reflectable.

import 'dart:core';
import 'package:alan/models/cosmos-sdk/tx/std_msg.dart' as prefix0;
import 'package:alan/models/messages/msg_send.dart' as prefix1;
import 'package:mooncake/sources/chain/models/msgs/msg_add_post_reaction.dart'
    as prefix7;
import 'package:mooncake/sources/chain/models/msgs/msg_answer_poll.dart'
    as prefix4;
import 'package:mooncake/sources/chain/models/msgs/msg_create_account.dart'
    as prefix3;
import 'package:mooncake/sources/chain/models/msgs/msg_create_post.dart'
    as prefix2;
import 'package:mooncake/sources/chain/models/msgs/msg_edit_account.dart'
    as prefix5;
import 'package:mooncake/sources/chain/models/msgs/msg_remove_post_reaction.dart'
    as prefix6;

// ignore_for_file: prefer_adjacent_string_concatenation
// ignore_for_file: prefer_collection_literals
// ignore_for_file: unnecessary_const
// ignore_for_file: implementation_imports

// ignore:unused_import
import 'package:reflectable/mirrors.dart' as m;
// ignore:unused_import
import 'package:reflectable/src/reflectable_builder_based.dart' as r;
// ignore:unused_import
import 'package:reflectable/reflectable.dart' as r show Reflectable;

final _data = <r.Reflectable, r.ReflectorData>{
  const prefix0.Reflector(): r.ReflectorData(
      <m.TypeMirror>[
        r.NonGenericClassMirrorImpl(
            r'MsgSend',
            r'.MsgSend',
            7,
            0,
            const prefix0.Reflector(),
            const <int>[-1],
            null,
            null,
            -1,
            {},
            {},
            {
              r'': (b) => ({fromAddress, toAddress, amount}) => b
                  ? prefix1.MsgSend(
                      amount: amount,
                      fromAddress: fromAddress,
                      toAddress: toAddress)
                  : null,
              r'fromJson': (b) =>
                  (json) => b ? prefix1.MsgSend.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            {}),
        r.NonGenericClassMirrorImpl(
            r'MsgCreatePost',
            r'.MsgCreatePost',
            7,
            1,
            const prefix0.Reflector(),
            const <int>[-1],
            null,
            null,
            -1,
            {},
            {},
            {
              r'': (b) => (
                      {parentId,
                      message,
                      allowsComments,
                      subspace,
                      optionalData,
                      creator,
                      creationDate,
                      medias,
                      poll}) =>
                  b
                      ? prefix2.MsgCreatePost(
                          allowsComments: allowsComments,
                          creationDate: creationDate,
                          creator: creator,
                          medias: medias,
                          message: message,
                          optionalData: optionalData,
                          parentId: parentId,
                          poll: poll,
                          subspace: subspace)
                      : null,
              r'fromJson': (b) =>
                  (json) => b ? prefix2.MsgCreatePost.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            {}),
        r.NonGenericClassMirrorImpl(
            r'MsgCreateAccount',
            r'.MsgCreateAccount',
            7,
            2,
            const prefix0.Reflector(),
            const <int>[-1],
            null,
            null,
            -1,
            {},
            {},
            {
              r'': (b) => ({moniker, name, surname, bio, pictures, creator}) =>
                  b
                      ? prefix3.MsgCreateAccount(
                          bio: bio,
                          creator: creator,
                          moniker: moniker,
                          name: name,
                          pictures: pictures,
                          surname: surname)
                      : null,
              r'fromJson': (b) =>
                  (json) => b ? prefix3.MsgCreateAccount.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            {}),
        r.NonGenericClassMirrorImpl(
            r'MsgAnswerPoll',
            r'.MsgAnswerPoll',
            7,
            3,
            const prefix0.Reflector(),
            const <int>[-1],
            null,
            null,
            -1,
            {},
            {},
            {
              r'': (b) => ({postId, answers, user}) => b
                  ? prefix4.MsgAnswerPoll(
                      answers: answers, postId: postId, user: user)
                  : null,
              r'fromJson': (b) =>
                  (json) => b ? prefix4.MsgAnswerPoll.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            {}),
        r.NonGenericClassMirrorImpl(
            r'MsgEditAccount',
            r'.MsgEditAccount',
            7,
            4,
            const prefix0.Reflector(),
            const <int>[-1],
            null,
            null,
            -1,
            {},
            {},
            {
              r'': (b) => (
                      {moniker,
                      name,
                      surname,
                      bio,
                      profilePicture,
                      coverPicture,
                      creator}) =>
                  b
                      ? prefix5.MsgEditAccount(
                          bio: bio,
                          coverPicture: coverPicture,
                          creator: creator,
                          moniker: moniker,
                          name: name,
                          profilePicture: profilePicture,
                          surname: surname)
                      : null,
              r'fromJson': (b) =>
                  (json) => b ? prefix5.MsgEditAccount.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            {}),
        r.NonGenericClassMirrorImpl(
            r'MsgRemovePostReaction',
            r'.MsgRemovePostReaction',
            7,
            5,
            const prefix0.Reflector(),
            const <int>[-1],
            null,
            null,
            -1,
            {},
            {},
            {
              r'': (b) => ({postId, reaction, user}) => b
                  ? prefix6.MsgRemovePostReaction(
                      postId: postId, reaction: reaction, user: user)
                  : null,
              r'fromJson': (b) => (json) =>
                  b ? prefix6.MsgRemovePostReaction.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            {}),
        r.NonGenericClassMirrorImpl(
            r'MsgAddPostReaction',
            r'.MsgAddPostReaction',
            7,
            6,
            const prefix0.Reflector(),
            const <int>[-1],
            null,
            null,
            -1,
            {},
            {},
            {
              r'': (b) => ({postId, reaction, user}) => b
                  ? prefix7.MsgAddPostReaction(
                      postId: postId, reaction: reaction, user: user)
                  : null,
              r'fromJson': (b) =>
                  (json) => b ? prefix7.MsgAddPostReaction.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            {})
      ],
      null,
      null,
      <Type>[
        prefix1.MsgSend,
        prefix2.MsgCreatePost,
        prefix3.MsgCreateAccount,
        prefix4.MsgAnswerPoll,
        prefix5.MsgEditAccount,
        prefix6.MsgRemovePostReaction,
        prefix7.MsgAddPostReaction
      ],
      7,
      {},
      {},
      null,
      [
        const [
          0,
          0,
          const [#fromAddress, #toAddress, #amount]
        ],
        const [1, 0, null],
        const [
          0,
          0,
          const [
            #parentId,
            #message,
            #allowsComments,
            #subspace,
            #optionalData,
            #creator,
            #creationDate,
            #medias,
            #poll
          ]
        ],
        const [
          0,
          0,
          const [#moniker, #name, #surname, #bio, #pictures, #creator]
        ],
        const [
          0,
          0,
          const [#postId, #answers, #user]
        ],
        const [
          0,
          0,
          const [
            #moniker,
            #name,
            #surname,
            #bio,
            #profilePicture,
            #coverPicture,
            #creator
          ]
        ],
        const [
          0,
          0,
          const [#postId, #reaction, #user]
        ]
      ])
};

final _memberSymbolMap = null;

void initializeReflectable() {
  r.data = _data;
  r.memberSymbolMap = _memberSymbolMap;
}
