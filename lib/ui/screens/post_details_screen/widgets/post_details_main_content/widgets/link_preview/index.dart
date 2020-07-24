import 'package:flutter/material.dart';
import './utils/preview_helper.dart';

class LinkPreview extends StatefulWidget {
  @override
  _LinkPreviewState createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  String url;
  Map<String, String> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Link Preview'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                url = value;
              });
            },
          ),
          RaisedButton(
            onPressed: () {
              FetchPreview().fetch(url).then((res) {
                setState(() {
                  data = res;
                });
              });
            },
            child: Text('Fetch'),
          ),
          _buildPreviewWidget()
        ],
      ),
    );
  }

  Widget _buildPreviewWidget() {
    if (data == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        color: Colors.lightGreen[100],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Image.network(
                data['image'],
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      data['description'],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: <Widget>[
                        Image.network(
                          data['favIcon'],
                          height: 12,
                          width: 12,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(url,
                            style: TextStyle(color: Colors.grey, fontSize: 12))
                      ],
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
