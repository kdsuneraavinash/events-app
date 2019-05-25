import 'package:cached_network_image/cached_network_image.dart';
import 'package:events/components/components.dart';
import 'package:events/theme/theme_controller.dart';
import 'package:events/ui/event_page/event_description.dart';
import 'package:events/ui/event_page/event_details.dart';
import 'package:events/components/interested_pin.dart';
import 'package:events/views/event.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

abstract class EventPage extends StatelessWidget {
  const EventPage({Key key}) : super(key: key);

  List<Widget> tabTitles() {
    return [
      Tab(child: Text("Basic")),
      Tab(child: Text("Descriptions")),
    ];
  }

  Widget tabContents() {
    return TabBarView(
      children: [EventDetails(), EventDescription()],
    );
  }

  Widget tabController({@required Widget child}) {
    return DefaultTabController(length: 2, initialIndex: 0, child: child);
  }
}

class MobileEventPage extends EventPage {
  @override
  Widget build(BuildContext context) {
    EventView eventView = Provider.of<EventView>(context);

    return Scaffold(
      body: super.tabController(
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [_headerSliverWidget(context)],
          body: super.tabContents(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Components.shareEvent(eventView),
        child: Icon(FontAwesomeIcons.share),
      ),
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            InterestedPin(
              eventView.iLiked,
              selectedText: "Unmark",
              unselectedText: "Mark",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerSliverWidget(BuildContext context) {
    return SliverAppBar(
      title: Text(Provider.of<EventView>(context).name),
      bottom: TabBar(
        tabs: super.tabTitles(),
      ),
      expandedHeight: MediaQuery.of(context).size.height * 0.35,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: Key(Provider.of<EventView>(context).name),
              child: CachedNetworkImage(
                imageUrl: Provider.of<EventView>(context).coverImageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => Center(
                      child: Icon(
                        FontAwesomeIcons.image,
                        size: 36.0,
                        color: Colors.white,
                      ),
                    ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff000000),
                    Color(0x00000000),
                    Color(0x88000000)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }
}

class TabletEventPage extends EventPage {
  @override
  Widget build(BuildContext context) {
    return super.tabController(
      child: Column(
        children: <Widget>[
          TabBar(
            labelColor:
                Provider.of<ThemeController>(context).theme.normalTextColor,
            tabs: super.tabTitles(),
          ),
          Expanded(child: super.tabContents())
        ],
      ),
    );
  }
}
