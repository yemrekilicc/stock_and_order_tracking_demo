import 'package:auto_size_text/auto_size_text.dart';
import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/size_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/utils/drawers/navigation_drawer.dart';
import 'package:siparis_takip_demo/model/musteriler_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_view/base_view.dart';
import '../viewmodel/contacts_viewmodel.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ContactsViewModel>(
      viewModel: ContactsViewModel(),
      onModelReady: (model) async {
        model.setContext(context);
        await model.init();
      },
      onPageBuilder: (context, viewModel, child) => SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if(context.isWideScreen)
              ...[
                const navigationDrawer()
              ],
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: context.isWideScreen?80:null,
                  title: context.isWideScreen?Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: SizeConstant.instance!.wideScreenWidth,
                          minWidth: 0),
                      child: TextField(
                        style: const TextStyle(fontSize: 20),
                        controller: viewModel.searchController,
                        onChanged: (input) {
                          viewModel.sortAndFilter();
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: ColorConstants
                              .instance.textFieldBackgroundColor,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ):null,
                  automaticallyImplyLeading: !context.isWideScreen,
                  backgroundColor: ColorConstants.instance.drawerTopColor,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    IconButton(
                        onPressed: () => viewModel.reloadMusteriler(),
                        icon: const Icon(
                          Icons.replay,
                        ))
                  ],
                ),
                key: viewModel.scaffoldKey,
                backgroundColor: ColorConstants.instance.backgroundColor,
                drawer:context.isWideScreen? null:const navigationDrawer(),
                body: buildBody(viewModel, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody(ContactsViewModel viewModel, BuildContext context) {
    return FutureBuilder<List<Musteriler>>(
      future: viewModel.musteriler,
      builder: (context, AsyncSnapshot<List<Musteriler>> snapshot) {
        Future.delayed(Duration.zero, () {
          if (snapshot.hasData) {
            if (snapshot != viewModel.lastSnapshot) {
              viewModel.orjList=List.of(snapshot.data!);
              viewModel.sortAndFilter();
              viewModel.lastSnapshot = snapshot;
            }
          }
        });
        return Column(
          children: [
            if(!context.isWideScreen)...[
              Container(
                decoration: BoxDecoration(
                  color: ColorConstants.instance.drawerTopColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: context.dynamicWidth(0.04),
                    right: context.dynamicWidth(0.04),
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          style: const TextStyle(fontSize: 20),
                          controller: viewModel.searchController,
                          onChanged: (input) {
                            viewModel.sortAndFilter();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor:
                            ColorConstants.instance.textFieldBackgroundColor,
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     showModalBottomSheet(
                      //       context: context,
                      //       isScrollControlled: true,
                      //       backgroundColor:
                      //       ColorConstants.instance.backgroundColor,
                      //       shape: const RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.vertical(
                      //           top: Radius.circular(20),
                      //         ),
                      //       ),
                      //       builder: (context) {
                      //         FocusScope.of(context).unfocus();
                      //         return BottomSheet(viewModel: viewModel);
                      //       },
                      //     );
                      //   },
                      //   icon: const Icon(
                      //     Icons.sort,
                      //     color: Colors.white,
                      //     size: 30,
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ],
            if (snapshot.connectionState == ConnectionState.waiting) ...[
              Center(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ] else if (snapshot.connectionState == ConnectionState.done) ...[
              if (snapshot.hasError) ...[
                const Text("hata oluştu")
              ] else if (snapshot.hasData) ...[
                Expanded(
                  child: ListView.builder(
                    key: const PageStorageKey<String>('page'),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount:
                    viewModel.musterilerSuggestion.length,
                    itemBuilder: (context, index) {
                      return MusteriCard(
                        viewModel: viewModel,
                        musteri: viewModel.musterilerSuggestion[index],
                        index: index,
                      );
                    },
                  ),
                )
              ] else ...[
                const Text("...")
              ]
            ] else ...[
              Text('State: ${snapshot.connectionState}')
            ]
          ],
        );
      },
    );
  }
}
class BottomSheet extends StatefulWidget {
  BottomSheet({
    required this.viewModel,
    super.key,
  });
  ContactsViewModel viewModel;
  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MusteriCard extends StatelessWidget {
  MusteriCard({
    required this.viewModel,
    required this.musteri,
    required this.index,
    super.key,
  });
  ContactsViewModel viewModel;
  Musteriler musteri;
  int index;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConstant.instance!.wideScreenWidth),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: ColorConstants.instance.siparisCardTopColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text(
                          //   viewModel.musterilerSuggestion[index]
                          //       .adi
                          //       .toUpperCase(),
                          //   style: const TextStyle(fontSize: 18),
                          // ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: AutoSizeText(
                              viewModel.musterilerSuggestion[index]
                                  .adi
                                  .toUpperCase(),
                              style: const TextStyle(fontSize: 18),
                              minFontSize: 14,
                              maxLines: 1,
                              textDirection: TextDirection.ltr,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                          Row(
                            children: [
                              PopupMenuButton<int>(
                                initialValue: viewModel.popUpMenuValue,
                                onSelected: (item) async{
                                  viewModel.popUpAction(item,index,context);
                                },
                                itemBuilder: (BuildContext context) =>[
                                  const PopupMenuItem(
                                    value: 0,
                                    child: Text('Güncelle'),

                                  ),
                                   const PopupMenuItem(
                                    value: 1,
                                    child: Text('Sil'),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Telefon: ${musteri.telefon==""?" ------ ":musteri.telefon}",
                          overflow: TextOverflow.fade,
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          "adres: ${musteri.adres==""?" ------ ":musteri.adres}",
                          overflow: TextOverflow.fade,
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          "aciklama: ${musteri.aciklama==""?" ------ ":musteri.aciklama}",
                          overflow: TextOverflow.fade,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 0,
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}