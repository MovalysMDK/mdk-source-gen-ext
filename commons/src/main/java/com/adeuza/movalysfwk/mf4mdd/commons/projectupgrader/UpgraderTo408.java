/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.commons.projectupgrader;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.a2a.adjava.projectupgrader.AbstractProjectUpgrader;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlDictionary;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml2xmodele.extractors.ScreenExtractor;
import com.a2a.adjava.uml2xmodele.ui.screens.PanelAggregation;
import com.a2a.adjava.uml2xmodele.ui.screens.ScreenContext;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.MVisualField;

public class UpgraderTo408 extends AbstractProjectUpgrader{

	private IDomain<IModelDictionary, IModelFactory> oDomain;


	@Override
	public void executeFixesForAndroid(
			IDomain<IModelDictionary, IModelFactory> p_oDomain,
			Map<String, ?> p_oGlobalSession) throws Exception {
		Map<String, Map<String, String>> oVisualFieldNamesMapping = new HashMap<>();
		this.oDomain = p_oDomain;
		ScreenExtractor oScreenExtractor = p_oDomain.getExtractor(ScreenExtractor.class);
		ScreenContext oScreenContext = oScreenExtractor.getScreenContext();



		UmlModel oUmlModele = (UmlModel) p_oGlobalSession.get("uml-model");

		UmlDictionary oUmlDict = oUmlModele.getDictionnary();

		for (UmlClass oUmlScreenClass : oScreenContext.getScreenUmlClasses(oUmlDict)) {
			// Create MScreen
			MScreen oScreen = p_oDomain.getDictionnary().getScreen(oUmlScreenClass.getName());
			this.processPanelAggregations(oScreen, oUmlScreenClass, oScreenContext, oVisualFieldNamesMapping);
		}
		System.out.println("MAPPING : " + oVisualFieldNamesMapping);
		this.writeChanges(oVisualFieldNamesMapping);
	}


	@Override
	public void executeFixesForIOS(
			IDomain<IModelDictionary, IModelFactory> p_oDomain,
			Map<String, ?> p_oGlobalSession) throws Exception {
	}




	/**
	 * Process aggregations between screens and panels
	 * 
	 * @param p_oScreen L'écran dont on souhaite recupérer les aggrégations
	 * @param p_oScreenUmlClass L'objet UML correspond à l'écran traité
	 * @param p_oScreenContext Le context
	 */
	private void processPanelAggregations(MScreen p_oScreen,
			UmlClass p_oScreenUmlClass, ScreenContext p_oScreenContext, Map<String, Map<String, String>> p_oVisualFieldNamesMapping) {

		// initialisation des panels liés au Screen courant
		List<PanelAggregation> listPanelAggregations = p_oScreenContext
				.getPanelAggregations(p_oScreenUmlClass);

		// screen has at least one panel
		if (!listPanelAggregations.isEmpty()) {


			// dans le cas du WorkspacePanel il y a plusieurs Panel
			for (PanelAggregation oPanelAggregation : listPanelAggregations) {

				String[] oPathMapping = null;
				// cas d'un panel de type liste
				if (p_oScreenContext.isListPanel(oPanelAggregation.getPanel())) {
					// panel of type list
					oPathMapping = treatListPanelAggregation(oPanelAggregation, p_oScreenUmlClass, p_oScreenContext);

				} else {
					// cas d'un panel simple/classique
					oPathMapping = treatPanelAggregation(oPanelAggregation, p_oScreenUmlClass, p_oScreenContext);
				}
				for(MPage oPage : p_oScreen.getPages()) {
					for(MVisualField oVisualField : oPage.getLayout().getFields()) {
						String sPanelName = oPage.getLayout().getName();
						String sCurrentFieldName = oVisualField.getName();
						String sNewFieldName = sCurrentFieldName.replaceFirst(oPathMapping[1], oPathMapping[0]);
						this.addToMapping(sNewFieldName, sCurrentFieldName, sPanelName, p_oVisualFieldNamesMapping);

						String sCurrentLabelName = oVisualField.getLabel().getKey();
						if(sCurrentLabelName != null) {
							String sNewLabelName = sCurrentLabelName.replaceFirst(oPathMapping[1], oPathMapping[0]);
							this.addToMapping(sNewLabelName, sCurrentLabelName, sPanelName, p_oVisualFieldNamesMapping);
						}
					}
				}
			}
		} 
	}

	/**
	 * @param p_oPanelAggregation Une PanelAggregation
	 * @param p_oScreenUmlClass La classe UML correspondant à l'écran traité
	 * @param p_oScreenContext Le contexte 
	 */
	private String[] treatPanelAggregation(PanelAggregation p_oPanelAggregation, 
			UmlClass p_oScreenUmlClass, ScreenContext p_oScreenContext) {

		//Récupération de l'ancien et du nouveau nom construit
		StringBuilder sOldPath = new StringBuilder();
		StringBuilder sNewPath = new StringBuilder();
		sOldPath.append(p_oScreenUmlClass.getName().toLowerCase());
		sNewPath.append(p_oPanelAggregation.getName().toLowerCase());
		sOldPath.append('_');
		sNewPath.append('_');

		return new String[] {sOldPath.toString(), sNewPath.toString()};
	}

	/**
	 * @param p_oPanelAggregation Une PanelAggregation
	 * @param p_oScreenUmlClass La classe UML correspondant à l'écran traité
	 * @param p_oScreenContext Le contexte 
	 */
	private String[] treatListPanelAggregation(
			PanelAggregation p_oPanelAggregation, UmlClass p_oScreenUmlClass,
			ScreenContext p_oScreenContext) {

		//Récupération de l'ancien et du nouveau nom construit
		StringBuilder sOldPath = new StringBuilder("list");
		StringBuilder sNewPath = new StringBuilder("list");
		sOldPath.append(p_oScreenUmlClass.getName().toLowerCase());
		sNewPath.append(p_oPanelAggregation.getName().toLowerCase());
		sOldPath.append('_');
		sNewPath.append('_');

		return new String[] {sOldPath.toString(), sNewPath.toString()};
	}

	/**
	 * Ajoute une entrée au mapping des anciens/nouveaux noms des champs
	 * @param p_sOldName L'ancien nom du champ
	 * @param p_sNewName Le nouveau nom du champ
	 * @param p_sLayoutName Le layout dans lequel se trouve le champ
	 * @param p_oVisualFieldNamesMapping Le mapping
	 */
	private void addToMapping(String p_sOldName, String p_sNewName, String p_sLayoutName, Map<String, Map<String, String>> p_oVisualFieldNamesMapping) {
		if(p_sOldName != null && !p_sOldName.equalsIgnoreCase(p_sNewName)) {
			String sLayoutNamePrefix = null;
			String[] sLayoutNameComponents = p_sLayoutName.split("__");
			if(sLayoutNameComponents != null && sLayoutNameComponents.length > 0) {
				sLayoutNamePrefix = sLayoutNameComponents[0];
			}
			if(sLayoutNamePrefix != null) {
				if(p_oVisualFieldNamesMapping.get(sLayoutNamePrefix) == null) {
					p_oVisualFieldNamesMapping.put(sLayoutNamePrefix, new HashMap<String, String>());
				}
				//Ajout de la correspondance normale + de liste
				p_oVisualFieldNamesMapping.get(sLayoutNamePrefix).put(p_sOldName, p_sNewName);
				p_oVisualFieldNamesMapping.get(sLayoutNamePrefix).put("sel"+p_sOldName, "sel"+p_sNewName);
				p_oVisualFieldNamesMapping.get(sLayoutNamePrefix).put("lst"+p_sOldName, "lst"+p_sNewName);
			}
		}
	}

	/**
	 * Ecris les modifications
	 * @param p_oVisualFieldNamesMapping Le mapping anciens/nouveaux noms
	 * @throws IOException Exeception
	 */
	private void writeChanges(Map<String, Map<String, String>> p_oVisualFieldNamesMapping) throws IOException {
		File oLayoutFolder = new File("mbandroid/application/res/layout/");
		File[] oListOfLayouts = oLayoutFolder.listFiles();

		Map<String, Map<String, String>> oEffectiveChangesMapping = new HashMap<>();
		for (int i = 0; i < oListOfLayouts.length; i++) {
			if(!oListOfLayouts[i].isHidden()) {
				System.out.println("UpgraderTo408 - Traitement du layout : " + oListOfLayouts[i].getCanonicalPath());
				this.replace(p_oVisualFieldNamesMapping, oListOfLayouts[i], oEffectiveChangesMapping);
			}
		}

		writeChangesLogFile(oEffectiveChangesMapping);
	}

	private void replace(Map<String, Map<String, String>> p_oVisualFieldNamesMapping, File oInOutLayoutFile, Map<String, Map<String, String>> p_oEffectiveChangesMapping) throws IOException {
		BufferedReader oBufferedReader = new BufferedReader(new InputStreamReader(new FileInputStream(oInOutLayoutFile), this.oDomain.getFileEncoding()));

		StringBuilder oFullLayoutContentBuilder = new StringBuilder();
		String line;
		while ((line = oBufferedReader.readLine()) != null) {
			oFullLayoutContentBuilder.append(line);
		}
		oBufferedReader.close();
		oBufferedReader = null;


		String sFinalLayoutContent = oFullLayoutContentBuilder.toString();

		boolean bContentHaschanged = false;
		//On ne souhaite remplacer que les ids de composants
		if(oInOutLayoutFile.getCanonicalPath().endsWith("xml")) {
			String sLayoutName = oInOutLayoutFile.getName().replace(".xml", "");
			String sLayoutNamePrefix = null;
			String[] sLayoutNameComponents = sLayoutName.split("__");
			if(sLayoutNameComponents != null && sLayoutNameComponents.length > 0 ) {
				sLayoutNamePrefix = sLayoutNameComponents[0];
			}

			if(sLayoutNamePrefix != null) {
				Map<String, String> oLayoutMapping = p_oVisualFieldNamesMapping.get(sLayoutNamePrefix);
				if(oLayoutMapping != null) {
					for(String sKey : oLayoutMapping.keySet()) {
						String p_sOccurence = sKey;
						String p_sReplacement = oLayoutMapping.get(sKey);
						if(sFinalLayoutContent.contains(p_sOccurence)) {
							if(p_oEffectiveChangesMapping.get(sLayoutName) == null) {
								p_oEffectiveChangesMapping.put(sLayoutName, new HashMap<String, String>());
							}
							p_oEffectiveChangesMapping.get(sLayoutName).put(p_sOccurence, p_sReplacement); 
							sFinalLayoutContent = sFinalLayoutContent.replaceAll("@id/"+p_sOccurence, "@id/"+p_sReplacement);
							sFinalLayoutContent = sFinalLayoutContent.replaceAll("@\\+id/"+p_sOccurence, "@\\+id/"+p_sReplacement);
							bContentHaschanged = true;
						}
					}
				}
			}
		}


		if(bContentHaschanged) {
			BufferedWriter oBufferedWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(oInOutLayoutFile), this.oDomain.getFileEncoding()));
			oBufferedWriter.write(sFinalLayoutContent);
			oBufferedWriter.close();
		}
	}



	private void writeChangesLogFile(Map<String, Map<String, String>> p_oEffectiveChangesMapping) throws IOException {
		File oLogFile = new File("version/UpgradeTo408.log");

		StringBuilder oContentBuilder = new StringBuilder();
		oContentBuilder.append(
				"La liste suivante représente pour chaque fichier layout XML, la liste des ids de composant qui ont été"
						+ "modifiés suite à la migration du projet en 4.0.8. (Ancien id / Nouvel id)\n "
						+ "Utilisez ce fichier pour corriger les ids dans vos blocs non-generated.\n\n");
		oContentBuilder.append(printChangesMap(p_oEffectiveChangesMapping));
		BufferedWriter oBufferedWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(oLogFile), this.oDomain.getFileEncoding()));
		oBufferedWriter.write(oContentBuilder.toString());
		oBufferedWriter.close();
	}


	private String printChangesMap(Map<String, Map<String, String>> p_oEffectiveChangesMapping) {

		StringBuilder oBuilder = new StringBuilder();
		for(String sLayoutKeyString : p_oEffectiveChangesMapping.keySet()) {
			oBuilder.append("*********************************************\n");
			oBuilder.append(sLayoutKeyString).append('\n');
			oBuilder.append("*********************************************\n");
			for(String sOccurenceKey : p_oEffectiveChangesMapping.get(sLayoutKeyString).keySet()) {
				oBuilder.append(sOccurenceKey).append('=').append(p_oEffectiveChangesMapping.get(sLayoutKeyString).get(sOccurenceKey));
				oBuilder.append('\n');
			}
			oBuilder.append('\n');
		}
		return oBuilder.toString();

	}

}



