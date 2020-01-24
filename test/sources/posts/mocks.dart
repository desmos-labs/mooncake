import 'package:mooncake/entities/entities.dart';

List<Post> getPosts() {
  return [
    Post(
      id: "1",
      parentId: "0",
      message: "Hello dreamers! ✨",
      created: "2020-01-21T13:16:10.123Z",
      lastEdited: "",
      allowsComments: true,
      subspace: "desmos",
      optionalData: {},
      owner: "desmos1y35fex9005709966jxkcqcz2vdvmtfyaj4x93h",
      reactions: [],
      commentsIds: [],
      status: PostStatus(value: PostStatusValue.SYNCED),
    ),
    Post(
      id: "2",
      parentId: "0",
      message: "Welcome to a new world of social media 🗣️",
      created: "2020-01-21T13:20:10.123Z",
      lastEdited: "",
      allowsComments: true,
      subspace: "desmos",
      optionalData: {},
      owner: "desmos16r460yaek3uqncjhnxez8v327qnxjw5k0crg9x",
      reactions: [
        Reaction(
          value: "😲",
          owner: "desmos1y35fex9005709966jxkcqcz2vdvmtfyaj4x93h",
        ),
        Reaction(
          value: "💯",
          owner: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl",
        )
      ],
      commentsIds: ["10"],
      status: PostStatus(value: PostStatusValue.SYNCED),
    ),
    Post(
      id: "3",
      parentId: "0",
      message: "Are you ready to get a piece of the cake? 🥮️",
      created: "2020-01-21T13:21:10.123Z",
      lastEdited: "",
      allowsComments: true,
      subspace: "desmos",
      optionalData: {},
      owner: "desmos15x3e6md5gdcsszc2nx88trnn85nn0qzgjwl9pj",
      reactions: [],
      commentsIds: [],
      status: PostStatus(value: PostStatusValue.SYNCING),
    ),
    Post(
      id: "4",
      parentId: "0",
      message: "Join now the social network revolution 💪",
      created: "2020-01-21T14:21:10.123Z",
      lastEdited: "",
      allowsComments: true,
      subspace: "desmos",
      optionalData: {},
      owner: "desmos15x3e6md5gdcsszc2nx88trnn85nn0qzgjwl9pj",
      reactions: [
        Reaction(
            value: "💢", owner: "desmos16f9wz7yg44pjfhxyn22kycs0qjy778ng877usl")
      ],
      commentsIds: [],
      status: PostStatus(value: PostStatusValue.TO_BE_SYNCED),
    ),
    Post(
      id: "5",
      parentId: "0",
      message: "Available for both Android and iOS 🤖🍎",
      created: "2020-01-21T14:22:10.123Z",
      lastEdited: "",
      allowsComments: true,
      subspace: "desmos",
      optionalData: {},
      owner: "desmos15x3e6md5gdcsszc2nx88trnn85nn0qzgjwl9pj",
      reactions: [],
      commentsIds: [],
      status: PostStatus(value: PostStatusValue.TO_BE_SYNCED),
    ),
  ];
}

List<Post> getComments() {
  return [
    Post(
      id: "10",
      parentId: "2",
      message: "I can't believe I'm part of this! 🤩",
      created: "2020-01-21T13:18:10.123Z",
      lastEdited: "",
      allowsComments: true,
      subspace: "desmos",
      optionalData: {},
      owner: "desmos1y35fex9005709966jxkcqcz2vdvmtfyaj4x93h",
      reactions: [],
      commentsIds: [],
      status: PostStatus(value: PostStatusValue.SYNCED),
    ),
    Post(
      id: "11",
      parentId: "2",
      message: "I can't believe I'm part of this! 🤩",
      created: "2020-01-21T13:18:10.123Z",
      lastEdited: "",
      allowsComments: true,
      subspace: "desmos",
      optionalData: {},
      owner: "desmos1y35fex9005709966jxkcqcz2vdvmtfyaj4x93h",
      reactions: [],
      commentsIds: [],
      status: PostStatus(value: PostStatusValue.SYNCED),
    ),
  ];
}
