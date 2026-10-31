enum Screen {
  home('Home', '首页', '0:1124'),
  welcome('Welcome', '欢迎', '0:1508'),
  mobile('Mobile number', '手机号码', '0:1490'),
  verification('Verification', '验证码', '0:1900'),
  password('Password', '密码', '0:1913'),
  fingerprint('Fingerprint', '指纹', '0:1553'),
  photo('Profile picture', '头像', '0:1561'),
  interest('Interests', '兴趣', '0:1580'),
  goal('Your goals', '目标', '0:1605'),
  gender('Gender', '性别', '0:1642'),
  fitness('Fitness level', '运动等级', '0:1664'),
  weight('Your weight', '初始体重', '0:1685'),
  permission('Notifications setup', '通知引导', '0:1746'),
  success('Ready to go', '引导完成', '0:1790'),
  steps('Steps', '步数', '0:825'),
  insight('Step insight', '步数洞察', '0:1807'),
  water('Hydration', '饮水', '0:1195'),
  nutrition('Nutrition', '营养', '0:893'),
  journal('Journal', '饮食日志', '0:912'),
  recipe('Recipes', '食谱', '0:1005'),
  food('Nutrition facts', '食物详情', '0:1041'),
  progress('Weight progress', '体重趋势', '0:443'),
  sleepReminder('Sleep reminder', '睡眠提醒', '0:329'),
  weightReminder('Weight reminder', '称重提醒', '0:370'),
  explore('Explore', '探索', '0:600'),
  tips('Sleep tips', '睡眠贴士', '0:667'),
  podcast('Podcast', '播客', '0:1393'),
  podcastDetails('Podcast details', '播客详情', '0:685'),
  player('Podcast player', '播放器', '0:801'),
  playlist('Share playlist', '分享歌单', '0:732'),
  challenge('Challenges', '运动挑战', '0:2'),
  events('Events', '活动', '0:54'),
  eventDetails('Event details', '活动详情', '0:245'),
  community('Community', '社区', '0:112'),
  createPost('Create post', '发布动态', '0:389'),
  poll('Health polls', '健康投票', '0:1301'),
  share('Share progress', '分享成就', '0:1279'),
  profile('Profile', '个人主页', '0:505'),
  premium('Go premium', '会员', '0:294'),
  notifications('Notifications', '通知', '0:1932'),
  invite('Invite friends', '邀请朋友', '0:1968'),
  feedback('Feedback', '体验反馈', '0:1328'),
  feedbackDetails('Feedback details', '反馈详情', '0:420');

  const Screen(this.title, this.label, this.pixsoId);
  final String title;
  final String label;
  final String pixsoId;
  String get path => '/$name';
  bool get hasNavigation => {
    Screen.home,
    Screen.podcast,
    Screen.explore,
    Screen.community,
    Screen.profile,
  }.contains(this);
  static Screen fromPath(String? path) => Screen.values.firstWhere(
    (s) => s.path == path,
    orElse: () => Screen.home,
  );
}
