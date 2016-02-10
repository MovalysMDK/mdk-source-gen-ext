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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.extractors;

import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.uml2xmodele.extractors.AbstractExtractor;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.MAdapter;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADictionnary;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4ADomain;
import com.adeuza.movalysfwk.mf4mdd.mbandroid.xmodele.MF4AModeleFactory;

/**
 * Used to generate javadoc on the classes created by the generator
 */

public class ClassesJavadocExtractor extends AbstractExtractor<MF4ADomain<MF4ADictionnary, MF4AModeleFactory>> {

	/**
	 * logger for class
	 */
	private static final Logger log = LoggerFactory.getLogger(ClassesJavadocExtractor.class);

	private boolean isActivated = false;
	
	@Override
	public void initialize(Element p_xConfig) throws Exception {
		isActivated = this.getParameters().getValue("activated", "false").equals("true");
	}
	
	@Override
	public void extract(UmlModel p_oModele) throws Exception {
		
		if (!isActivated) {
			log.debug("> ClassesJavadocExtractor is deactivated.");
			return;
		}
		
		log.debug("> ClassesJavadocExtractor.extract");
		Chrono oChrono = new Chrono(true);
		
		String sDoc = null;
		
		// factories
		for (MEntityImpl oEntity : this.getDomain().getDictionnary().getAllEntities()) {
			sDoc = "Factory for " + oEntity.getEntityName();
			oEntity.getFactory().setDocumentation(sDoc);
			sDoc = "Factory interface for " + oEntity.getEntityName();
			oEntity.getFactoryInterface().setDocumentation(sDoc);
		}

		// dataloaders
		for (MDataLoader oDataloader : this.getDomain().getDictionnary().getAllDataLoaders()) {
			sDoc = "Dataloader for " + oDataloader.getMasterInterface().getEntity().getEntityName();
			oDataloader.setDocumentation(sDoc);
			sDoc = "Dataloader interface for " + oDataloader.getMasterInterface().getEntity().getEntityName();
			oDataloader.getMasterInterface().setDocumentation(sDoc);
		}
		
		// view models
		for (MViewModelImpl oViewModel : this.getDomain().getDictionnary().getAllViewModels()) {
			
			if (oViewModel.getDocumentation() == null || oViewModel.getDocumentation().length() == 0) {
				if (oViewModel.getEntityToUpdate() != null) {
					sDoc = "View model for entity " + oViewModel.getEntityToUpdate().getEntityName();
				} else {
					sDoc = "View model for panel " + oViewModel.getUmlName();
				}
				
				oViewModel.setDocumentation(sDoc);
			}
			
			if (oViewModel.getMasterInterface().getDocumentation() == null || oViewModel.getMasterInterface().getDocumentation().length() == 0) {
				if (oViewModel.getEntityToUpdate() != null) {
					sDoc = "View model interface for entity " + oViewModel.getEntityToUpdate().getEntityName();
				} else {
					sDoc = "View model interface for panel " + oViewModel.getUmlName();
				}
				
				oViewModel.getMasterInterface().setDocumentation(sDoc);
			}
		}
		
		// panels
		for(MPage oPage : this.getDomain().getDictionnary().getAllPanels()) {
			sDoc = "Panel " + oPage.getName();
			oPage.setDocumentation(sDoc);
		}
		
		// save actions
		for(MAction oAction : this.getDomain().getDictionnary().getAllActions()) {
			if (oAction.getType().equals(MActionType.SAVEDETAIL)) {
				sDoc = "Save action on " + oAction.getEntity().getName();
				oAction.setDocumentation(sDoc);
				
				sDoc = "Save action interface on " + oAction.getEntity().getName();
				oAction.getMasterInterface().setDocumentation(sDoc);
			}
		}
		
		// adapters
		for (MAdapter oAdapter : this.getDomain().getDictionnary().getAllAdapters()) {
			sDoc = "Adapter " + oAdapter.getName();
			oAdapter.setDocumentation(sDoc);
		}
		
		// TODO action providers (?)
		
		log.debug("< ClassesJavadocExtractor.extract: {}", oChrono.stopAndDisplay());
	}

	
}