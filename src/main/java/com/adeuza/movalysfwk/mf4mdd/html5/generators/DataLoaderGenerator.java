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
package com.adeuza.movalysfwk.mf4mdd.html5.generators;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.html5.xmodele.MH5ImportDelegate;
import com.a2a.adjava.languages.html5.xmodele.MH5Domain;
import com.a2a.adjava.languages.html5.xmodele.MH5Dictionary;
import com.a2a.adjava.languages.html5.xmodele.MH5ModeleFactory;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MAssociation.AssociationType;
import com.a2a.adjava.xmodele.MCascade;
import com.a2a.adjava.xmodele.MScreen;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoaderCombo;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;

/**
 * <p>génération de controller view.</p>
 *
 */
public class DataLoaderGenerator extends AbstractIncrementalGenerator<MH5Domain<MH5Dictionary, MH5ModeleFactory>> {

	
	
	/** Logger pour la classe courante */
	private static final Logger log = LoggerFactory.getLogger(DataLoaderGenerator.class);
	
	private static final String docPath = "webapp/src/app/views/";

	/**
	 * {@inheritDoc}
	 */
	@Override
	public void genere(XProject<MH5Domain<MH5Dictionary, MH5ModeleFactory>> p_oProject, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> DataLoaderGenerator.genere");
		Chrono oChrono = new Chrono(true);

		MFModelDictionary oDictionnary = (MFModelDictionary) p_oProject.getDomain().getDictionnary();

		for (MDataLoader oMDataLoader : oDictionnary.getAllDataLoaders()) {
				this.createDataLoaderFile(oMDataLoader, p_oProject, p_oContext);
		}
		


		log.debug("< DataLoaderGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	/**
	 * <p>Génération du nouveau javascript de controller.</p>
	 * @param p_oMH5View le view de référence
	 * @param p_oMProject le flux xml à utiliser avec la xsl pour la génération de l'écran
	 * @param p_mapSession la session
	 * @throws Exception erreur lors de la génération
	 */
	private void createDataLoaderFile(MDataLoader p_oMDataLoader, 
			XProject<MH5Domain<MH5Dictionary, MH5ModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {
		
		MScreen oWorkspaceScreen = null;
		String docControllerPath = "";
		
		for (MScreen oScreen : p_oMProject.getDomain().getDictionnary().getAllScreens()) {
			if (oScreen.isWorkspace()) {
				// TODO genereate dataloader in a other path
				if (p_oMDataLoader.getUmlName().equals(oScreen.getName()+ "Detail")) {
					oWorkspaceScreen = oScreen;
				}
				
			}
		}
		if (oWorkspaceScreen != null) {
			docControllerPath = docPath + oWorkspaceScreen.getName();
		} else {
			docControllerPath = docPath + p_oMDataLoader.getUmlName();
		}
		
		Element r_xFile = p_oMDataLoader.toXml();
		r_xFile.addElement("master-package").setText(p_oMProject.getDomain().getRootPackage());
		if (oWorkspaceScreen != null) {
			r_xFile.addElement("viewName").setText("view_"+oWorkspaceScreen.getName());
		} else {
			r_xFile.addElement("viewName").setText("view_"+p_oMDataLoader.getUmlName());
		}
		
		
		MH5ImportDelegate oMH5ImportDelegate = p_oMProject.getDomain().getXModeleFactory().createImportDelegate(this);
		this.computeImportForDataLoader(oMH5ImportDelegate, p_oMDataLoader, p_oMProject, p_oContext);
		r_xFile.add(oMH5ImportDelegate.toXml());
		
		Document xDoc = DocumentHelper.createDocument(r_xFile);

		String sFile = FileTypeUtils.computeFilenameForJS(docControllerPath, p_oMDataLoader.getName());
		
		String sModele = "dataloader/dataloader-impl.xsl";

		log.debug("  generation du fichier: {}", sFile);
		this.doIncrementalTransform(sModele, sFile, xDoc, p_oMProject, p_oContext);
	}
	


	/**
	 * Compute imports for dataloader implementation
	 * @param p_oMDataLoader dataloader
	 * @param p_oMProject project
	 * @param p_oContext context
	 * @throws Exception
	 */
	protected void computeImportForDataLoader( MH5ImportDelegate p_oMH5ImportDelegate,
			MDataLoader p_oMDataLoader, XProject<MH5Domain<MH5Dictionary, MH5ModeleFactory>> p_oMProject,
			DomainGeneratorContext p_oContext) throws Exception {
		if(p_oMDataLoader.getLoadDao() != null)
		{
			p_oMH5ImportDelegate.addImport(p_oMDataLoader.getLoadDao().getName()+"Proxy");
		}
		
		for (MAssociation oAssociation : p_oMDataLoader.getMasterInterface().getEntity().getAssociations()) {
			if (oAssociation.getAssociationType().equals(AssociationType.MANY_TO_ONE)) {
				p_oMH5ImportDelegate.addImport(oAssociation.getRefClass().getDao().getName()+"Proxy");
			}
		}
		
		for(MDataLoaderCombo combo : p_oMDataLoader.getMasterInterface().getCombos()){
			p_oMH5ImportDelegate.addImport(combo.getEntityDao().getName()+"Proxy" );
		}
		if(p_oMDataLoader.getLoadDao()!=null &&
			p_oMDataLoader.getLoadDao().getMEntityImpl()!=null && 
		    p_oMDataLoader.getLoadDao().getMEntityImpl().getFactory()!=null && 
		   	p_oMDataLoader.getLoadDao().getMEntityImpl().getFactory().getName()!=null)
			p_oMH5ImportDelegate.addImport(p_oMDataLoader.getLoadDao().getMEntityImpl().getFactory().getName() );
	}
	
	
}
