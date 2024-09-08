import "package:flutter/material.dart";
import "package:sumit_onex_flutter/projects/inproduction/dio_singleton_template/models/catfact_model.dart";

import "../../global/custom_app_drawer.dart";
import "../data/remote/cat_api_service.dart";
import "../models/catbreeds_model.dart";

class CatFactsScreen extends StatefulWidget {
  const CatFactsScreen({super.key});

  @override
  State<CatFactsScreen> createState() => _CatFactsScreenState();
}

class _CatFactsScreenState extends State<CatFactsScreen> {
  //
  //
  // var
  CatfactModel catFactData = CatfactModel(fact: "", length: 1);
  CatBreedsModel catBreedsData = CatBreedsModel(path: "", perPage: 1, total: 1);

  //
  //
  // states
  @override
  void initState() {
    super.initState();
  }

  //
  //
  // func
  void fetchCatfactData() async {
    catFactData = await CatApiService().fetchCatFact();
    setState(() {});
  }

  void fetchCatBreedsData() async {
    catBreedsData = await CatApiService().fetchCatBreeds();
    setState(() {});
  }

  //
  //
  // ui
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomAppDrawer(),
        appBar: AppBar(
          title: const Text('Dio Singleton Example'),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    Image.network(
                        height: 100,
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Tabby_cat_with_visible_nictitating_membrane.jpg/800px-Tabby_cat_with_visible_nictitating_membrane.jpg"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("FACT:  ${catFactData.fact}"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("LENGTH: ${catFactData.length}"),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    fetchCatfactData();
                  },
                  child: const Text("Fetch Facts")),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    Image.network(
                        height: 100,
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Tabby_cat_with_visible_nictitating_membrane.jpg/800px-Tabby_cat_with_visible_nictitating_membrane.jpg"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("PATH:  ${catBreedsData.path}"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("LENGTH: ${catBreedsData.total}"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("PERPAGE: ${catBreedsData.perPage}"),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    fetchCatBreedsData();
                  },
                  child: const Text("Fetch Breeds Info")),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
